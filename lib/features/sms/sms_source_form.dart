import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/tn_phone.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sheet_header.dart';

/// Bottom-sheet form to create or edit an SMS data source (a tracked sender
/// number + a display name).
class SmsSourceForm extends ConsumerStatefulWidget {
  const SmsSourceForm({super.key, this.source});

  final SmsSource? source;

  @override
  ConsumerState<SmsSourceForm> createState() => _SmsSourceFormState();
}

class _SmsSourceFormState extends ConsumerState<SmsSourceForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.source?.name ?? '');
    // `+216` is shown as a fixed, non-editable prefix (see [InputDecoration]);
    // the field itself holds only the 8-digit subscriber number. When editing,
    // strip the stored country code down to those 8 digits.
    _phone = TextEditingController(
      text: widget.source != null
          ? TnPhone.matchKey(widget.source!.phoneNumber) ?? ''
          : '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(smsSourceRepositoryProvider);
    final name = _name.text.trim();
    // Validation guarantees this is non-null; store the canonical +216 form.
    final phone = TnPhone.normalize(_phone.text)!;
    if (widget.source == null) {
      await repo.insert(
        SmsSourcesCompanion.insert(name: name, phoneNumber: phone),
      );
    } else {
      await repo.update(
        widget.source!.copyWith(name: name, phoneNumber: phone),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SheetHeader(
                    title:
                        widget.source == null ? l.addSmsSource : l.editSmsSource,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(labelText: l.smsSourceName),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l.fieldRequired
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _phone,
                    decoration: InputDecoration(
                      labelText: l.phoneNumber,
                      helperText: l.phoneNumberHint,
                      // Fixed country code: part of the decoration, so the user
                      // can never delete or edit it.
                      prefixText: '+216 ',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    validator: (v) => TnPhone.normalize(v ?? '') == null
                        ? l.invalidTunisianNumber
                        : null,
                  ),
                ],
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

Future<void> showSmsSourceForm(BuildContext context, {SmsSource? source}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => SmsSourceForm(source: source),
  );
}
