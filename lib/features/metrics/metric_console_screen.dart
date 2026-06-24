import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';

/// A terminal-style live feed showing every raw message received on a metric's
/// topic, numeric or not. Numeric payloads (stored as readings) are shown in
/// green; payloads the app ignores are shown in amber.
class MetricConsoleScreen extends ConsumerStatefulWidget {
  const MetricConsoleScreen({super.key, required this.metric});

  final Metric metric;

  @override
  ConsumerState<MetricConsoleScreen> createState() =>
      _MetricConsoleScreenState();
}

class _MetricConsoleScreenState extends ConsumerState<MetricConsoleScreen> {
  static const _maxLines = 500;

  final _lines = <RawMessage>[];
  final _scrollController = ScrollController();
  final _timeFormat = DateFormat('HH:mm:ss.SSS');
  final _publishController = TextEditingController();
  final _publishFocus = FocusNode();
  StreamSubscription<RawMessage>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = ref
        .read(mqttServiceProvider)
        .rawMessages
        .where((m) => m.topic == widget.metric.topic)
        .listen(_onMessage);
  }

  void _onMessage(RawMessage msg) {
    if (!mounted) return;
    setState(() {
      _lines.add(msg);
      if (_lines.length > _maxLines) {
        _lines.removeRange(0, _lines.length - _maxLines);
      }
    });
    _scrollToBottom();
  }

  /// Publishes the current input on the metric's topic, clears the field, and
  /// keeps the keyboard up so the user can send another message right away.
  void _publish() {
    final text = _publishController.text.trim();
    if (text.isEmpty) return;
    ref.read(connectionProvider.notifier).publish(widget.metric.topic, text);
    _publishController.clear();
    _publishFocus.requestFocus();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    _publishController.dispose();
    _publishFocus.dispose();
    super.dispose();
  }

  /// A one-line diagnostic explaining whether messages can arrive, so an empty
  /// console is never silently ambiguous.
  Widget _statusBanner(AppLocalizations l) {
    final status = ref.watch(connectionProvider);
    final activeBrokerId =
        ref.read(connectionProvider.notifier).activeBrokerId;

    late final Color color;
    late final String text;
    if (status != MqttStatus.connected) {
      color = const Color(0xFF8B0000);
      text = '● ${l.disconnected}';
    } else if (activeBrokerId != widget.metric.brokerId) {
      color = const Color(0xFF8A6D00);
      text = '● ${l.connected} (${l.brokers})';
    } else {
      color = const Color(0xFF1B5E20);
      text = '● ${l.connected} — ${widget.metric.topic}';
    }

    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'monospace',
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.metric.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.metric.topic,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: l.clear,
            onPressed: _lines.isEmpty ? null : () => setState(_lines.clear),
          ),
        ],
      ),
      body: Column(
        children: [
          _statusBanner(l),
          Expanded(
            child: _lines.isEmpty
                ? Center(
                    child: Text(
                      l.consoleWaiting,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontFamily: 'monospace',
                      ),
                    ),
                  )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _lines.length,
              itemBuilder: (context, i) {
                final m = _lines[i];
                final isNumeric = m.numeric != null;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: '${_timeFormat.format(m.timestamp)}  ',
                          style: const TextStyle(color: Colors.white38),
                        ),
                        TextSpan(
                          text: m.payload,
                          style: TextStyle(
                            color: isNumeric
                                ? const Color(0xFF4CD964)
                                : const Color(0xFFFFB300),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
                  ),
          ),
          _publishBar(l),
        ],
      ),
    );
  }

  /// Bottom bar to publish on the metric's topic. Enabled only when the metric
  /// allows publishing and we're connected to its broker; otherwise it shows a
  /// disabled hint so the reason is never ambiguous.
  Widget _publishBar(AppLocalizations l) {
    final connectedHere =
        ref.watch(connectionProvider) == MqttStatus.connected &&
            ref.read(connectionProvider.notifier).activeBrokerId ==
                widget.metric.brokerId;
    final canPublish = widget.metric.publishEnabled && connectedHere;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
        ),
        child: widget.metric.publishEnabled
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _publishController,
                      focusNode: _publishFocus,
                      enabled: connectedHere,
                      onSubmitted: (_) => canPublish ? _publish() : null,
                      textInputAction: TextInputAction.send,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFF0D0D0D),
                        hintText: l.publishMessage,
                        hintStyle: const TextStyle(color: Colors.white38),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: AppColors.primary,
                    disabledColor: Colors.white24,
                    tooltip: l.publishMessage,
                    onPressed: canPublish ? _publish : null,
                  ),
                ],
              )
            : Row(
                children: [
                  const Icon(Icons.block, color: Colors.white38, size: 16),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l.publishDisabled,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
