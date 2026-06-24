import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sheet_header.dart';

/// Bottom-sheet form to create or edit a broker.
class BrokerForm extends ConsumerStatefulWidget {
  const BrokerForm({super.key, this.broker});

  final Broker? broker;

  @override
  ConsumerState<BrokerForm> createState() => _BrokerFormState();
}

class _BrokerFormState extends ConsumerState<BrokerForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _port;
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _keepAlive;
  late final TextEditingController _timeout;
  bool _obscurePassword = true;
  bool _testing = false;

  /// Inline result of the last connection test: the message and whether it
  /// succeeded. Null until a test has run. Shown in the sheet because a
  /// ScaffoldMessenger snackbar would render behind this modal bottom sheet.
  String? _testMessage;
  bool _testOk = false;
  late bool _secure;
  late bool _retain;
  late int _qos;

  @override
  void initState() {
    super.initState();
    final b = widget.broker;
    _name = TextEditingController(text: b?.name ?? '');
    _address = TextEditingController(text: b?.address ?? '');
    _port = TextEditingController(text: b?.port.toString() ?? '1883');
    _username = TextEditingController(text: b?.username ?? '');
    _password = TextEditingController(text: b?.password ?? '');
    _keepAlive = TextEditingController(text: (b?.keepAlive ?? 30).toString());
    _timeout = TextEditingController(
      text: (b?.connectTimeout ?? 10).toString(),
    );
    _secure = b?.secure ?? false;
    _retain = b?.retain ?? false;
    _qos = b?.qos ?? 0;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _port.dispose();
    _username.dispose();
    _password.dispose();
    _keepAlive.dispose();
    _timeout.dispose();
    super.dispose();
  }

  /// Flip the port between the standard MQTT (1883) and MQTT-over-TLS (8883)
  /// defaults when toggling TLS — but only if the user hasn't set a custom one.
  void _onSecureChanged(bool value) {
    setState(() {
      _secure = value;
      if (value && _port.text.trim() == '1883') {
        _port.text = '8883';
      } else if (!value && _port.text.trim() == '8883') {
        _port.text = '1883';
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(brokerRepositoryProvider);
    final username = _username.text.trim().isEmpty
        ? null
        : _username.text.trim();
    final password = _password.text.isEmpty ? null : _password.text;

    final keepAlive = int.tryParse(_keepAlive.text) ?? 30;
    final timeout = int.tryParse(_timeout.text) ?? 10;

    if (widget.broker == null) {
      await repo.insert(
        BrokersCompanion.insert(
          name: _name.text.trim(),
          address: _address.text.trim(),
          port: int.parse(_port.text),
          username: Value(username),
          password: Value(password),
          secure: Value(_secure),
          keepAlive: Value(keepAlive),
          connectTimeout: Value(timeout),
          qos: Value(_qos),
          retain: Value(_retain),
        ),
      );
    } else {
      await repo.update(
        widget.broker!.copyWith(
          name: _name.text.trim(),
          address: _address.text.trim(),
          port: int.parse(_port.text),
          username: Value(username),
          password: Value(password),
          secure: _secure,
          keepAlive: keepAlive,
          connectTimeout: timeout,
          qos: _qos,
          retain: _retain,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  /// Validates only the fields needed to reach the broker, then attempts a
  /// throwaway connection and reports the result inline.
  Future<void> _test() async {
    final l = AppLocalizations.of(context);
    // Surface inline errors on every required field before attempting a connect.
    if (!_formKey.currentState!.validate()) return;
    final address = _address.text.trim();
    final port = int.parse(_port.text);

    setState(() {
      _testing = true;
      _testMessage = null;
    });
    final username = _username.text.trim().isEmpty
        ? null
        : _username.text.trim();
    final reason = await testBrokerConnection(
      address: address,
      port: port,
      username: username,
      password: _password.text.isEmpty ? null : _password.text,
      secure: _secure,
      keepAlive: int.tryParse(_keepAlive.text) ?? 30,
      connectTimeout: int.tryParse(_timeout.text) ?? 10,
    );
    if (!mounted) return;

    final message = reason == null
        ? l.connectionSuccessful
        : l.unableToConnect(switch (reason) {
            MqttFailureReason.badCredentials => l.reasonBadCredentials,
            MqttFailureReason.brokerUnavailable => l.reasonBrokerUnavailable,
            MqttFailureReason.rejected => l.reasonRejected,
            MqttFailureReason.network => l.reasonNetwork,
            MqttFailureReason.unknown => l.reasonUnknown,
          });
    setState(() {
      _testing = false;
      _testOk = reason == null;
      _testMessage = message;
    });
  }

  String? _positiveIntValidator(String? v) {
    final n = int.tryParse(v ?? '');
    return (n == null || n < 1)
        ? AppLocalizations.of(context).invalidValue
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SheetHeader(
                      title: widget.broker == null ? l.addBroker : l.editBroker,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(labelText: l.brokerName),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _address,
                      decoration: InputDecoration(labelText: l.brokerAddress),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _port,
                      decoration: InputDecoration(labelText: l.brokerPort),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final p = int.tryParse(v ?? '');
                        return (p == null || p < 1 || p > 65535)
                            ? l.invalidPort
                            : null;
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.secureTls),
                      value: _secure,
                      onChanged: _onSecureChanged,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _username,
                      decoration: InputDecoration(labelText: l.username),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: l.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      obscureText: _obscurePassword,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.only(
                          top: AppSpacing.sm,
                          bottom: AppSpacing.sm,
                        ),
                        title: Text(l.advanced),
                        children: [
                          DropdownButtonFormField<int>(
                            initialValue: _qos,
                            isExpanded: true,
                            decoration: InputDecoration(labelText: l.qos),
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('0 — at most once'),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('1 — at least once'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('2 — exactly once'),
                              ),
                            ],
                            onChanged: (v) => setState(() => _qos = v ?? 0),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _keepAlive,
                                  decoration: InputDecoration(
                                    labelText: l.keepAliveSeconds,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: _positiveIntValidator,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: TextFormField(
                                  controller: _timeout,
                                  decoration: InputDecoration(
                                    labelText: l.timeoutSeconds,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: _positiveIntValidator,
                                ),
                              ),
                            ],
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l.retain),
                            value: _retain,
                            onChanged: (v) => setState(() => _retain = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: _testing ? null : _test,
                      icon: _testing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_tethering),
                      label: Text(_testing ? l.testing : l.testConnection),
                    ),
                    if (_testMessage != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(
                            _testOk ? Icons.check_circle : Icons.error,
                            color: _testOk
                                ? AppColors.success
                                : AppColors.danger,
                            size: 18,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _testMessage!,
                              style: TextStyle(
                                color: _testOk
                                    ? AppColors.success
                                    : AppColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, AppSpacing.md, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton(onPressed: _save, child: Text(l.save)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper to present the form as a modal bottom sheet.
Future<void> showBrokerForm(BuildContext context, {Broker? broker}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => BrokerForm(broker: broker),
  );
}
