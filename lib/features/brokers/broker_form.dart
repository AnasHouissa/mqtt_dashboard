import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

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

  @override
  void initState() {
    super.initState();
    final b = widget.broker;
    _name = TextEditingController(text: b?.name ?? '');
    _address = TextEditingController(text: b?.address ?? '');
    _port = TextEditingController(text: b?.port.toString() ?? '1883');
    _username = TextEditingController(text: b?.username ?? '');
    _password = TextEditingController(text: b?.password ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _port.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(brokerRepositoryProvider);
    final username = _username.text.trim().isEmpty ? null : _username.text.trim();
    final password = _password.text.isEmpty ? null : _password.text;

    if (widget.broker == null) {
      await repo.insert(BrokersCompanion.insert(
        name: _name.text.trim(),
        address: _address.text.trim(),
        port: int.parse(_port.text),
        username: Value(username),
        password: Value(password),
      ));
    } else {
      await repo.update(widget.broker!.copyWith(
        name: _name.text.trim(),
        address: _address.text.trim(),
        port: int.parse(_port.text),
        username: Value(username),
        password: Value(password),
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.broker == null ? l.addBroker : l.editBroker,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: l.brokerName),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
            ),
            TextFormField(
              controller: _address,
              decoration: InputDecoration(labelText: l.brokerAddress),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
            ),
            TextFormField(
              controller: _port,
              decoration: InputDecoration(labelText: l.brokerPort),
              keyboardType: TextInputType.number,
              validator: (v) {
                final p = int.tryParse(v ?? '');
                return (p == null || p < 1 || p > 65535) ? l.invalidPort : null;
              },
            ),
            TextFormField(
              controller: _username,
              decoration: InputDecoration(labelText: l.username),
            ),
            TextFormField(
              controller: _password,
              decoration: InputDecoration(labelText: l.password),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l.cancel),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _save, child: Text(l.save)),
              ],
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
