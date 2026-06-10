import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';

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

  /// Dev helper: insert one sine sample per day for the past [days] days, so
  /// the Day chart shows a full curve without waiting for real time to pass.
  /// MQTT can't do this — it always stamps readings with the current time.
  Future<void> _seedMockData({int days = 30}) async {
    const offset = 50.0, amplitude = 40.0, period = 30.0;
    final repo = ref.read(readingRepositoryProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 12);
    for (var i = 0; i < days; i++) {
      final ts = today.subtract(Duration(days: days - 1 - i));
      final value = offset + amplitude * sin(2 * pi * i / period);
      await repo.insert(widget.metric.id, value, ts);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).mockDataSeeded)),
    );
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
            Text(widget.metric.name),
            Text(
              widget.metric.topic,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ],
        ),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.auto_graph),
              tooltip: l.seedMockData,
              onPressed: _seedMockData,
            ),
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
        ],
      ),
    );
  }
}
