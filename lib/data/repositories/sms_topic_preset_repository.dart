import 'package:drift/drift.dart';

import '../db/database.dart';

/// CRUD + reactive reads for reusable SMS topic presets (e.g. `DOOR ALERT`).
/// These are global, source-independent labels surfaced as a dropdown when
/// creating SMS metrics.
class SmsTopicPresetRepository {
  SmsTopicPresetRepository(this._db);

  final AppDatabase _db;

  Stream<List<SmsTopicPreset>> watchAll() => (_db.select(_db.smsTopicPresets)
        ..orderBy([(t) => OrderingTerm(expression: t.label)]))
      .watch();

  Future<List<SmsTopicPreset>> getAll() =>
      _db.select(_db.smsTopicPresets).get();

  /// Inserts a preset, silently ignoring the insert when the label already
  /// exists (the table has a UNIQUE constraint on `label`).
  Future<void> insert(String label) => _db.into(_db.smsTopicPresets).insert(
        SmsTopicPresetsCompanion.insert(label: label),
        mode: InsertMode.insertOrIgnore,
      );

  Future<int> delete(int id) =>
      (_db.delete(_db.smsTopicPresets)..where((t) => t.id.equals(id))).go();
}
