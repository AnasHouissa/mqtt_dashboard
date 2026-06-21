import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';

/// Per-source raw SMS log (debug inbox): every received message with its parse
/// outcome, newest first.
class SmsLogView extends ConsumerWidget {
  const SmsLogView({super.key, required this.smsSourceId});

  final int smsSourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final messages = ref.watch(smsMessagesProvider(smsSourceId));

    return messages.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) {
        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.inbox_outlined,
            message: l.noSmsMessages,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            96,
          ),
          itemCount: list.length,
          itemBuilder: (context, i) => _LogCard(message: list[i]),
        );
      },
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard({required this.message});

  final SmsMessage message;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (Color color, String label) = switch (message.status) {
      SmsParseStatus.matched => (AppColors.success, l.smsStatusMatched),
      SmsParseStatus.unmatched => (AppColors.warning, l.smsStatusUnmatched),
      SmsParseStatus.error => (AppColors.danger, l.smsStatusError),
    };
    final time = DateFormat('MMM d · HH:mm:ss').format(message.receivedAt);

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusChip(color: color, label: label),
              const Spacer(),
              if (message.readingsCreated > 0)
                Text(
                  l.smsReadings(message.readingsCreated),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message.body,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${message.sender} · $time',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
