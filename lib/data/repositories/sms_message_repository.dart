import 'package:drift/drift.dart';

import '../db/database.dart';

/// Stores and reads the raw SMS log (debug inbox) for each SMS source.
class SmsMessageRepository {
  SmsMessageRepository(this._db);

  final AppDatabase _db;

  /// Recent messages for a source, newest first, capped to [limit] rows.
  Stream<List<SmsMessage>> watchForSource(int smsSourceId, {int limit = 100}) =>
      (_db.select(_db.smsMessages)
            ..where((m) => m.smsSourceId.equals(smsSourceId))
            ..orderBy([
              (m) => OrderingTerm(
                    expression: m.receivedAt,
                    mode: OrderingMode.desc,
                  ),
            ])
            ..limit(limit))
          .watch();

  Future<int> insert({
    required int smsSourceId,
    required String sender,
    required String body,
    required DateTime receivedAt,
    required SmsParseStatus status,
    int readingsCreated = 0,
  }) {
    return _db.into(_db.smsMessages).insert(
          SmsMessagesCompanion.insert(
            smsSourceId: smsSourceId,
            sender: sender,
            body: body,
            receivedAt: receivedAt,
            status: status,
            readingsCreated: Value(readingsCreated),
          ),
        );
  }

  /// Delete log rows for a source older than [cutoff] (housekeeping).
  Future<int> purgeOlderThan(int smsSourceId, DateTime cutoff) =>
      (_db.delete(_db.smsMessages)
            ..where((m) =>
                m.smsSourceId.equals(smsSourceId) &
                m.receivedAt.isSmallerThanValue(cutoff)))
          .go();
}
