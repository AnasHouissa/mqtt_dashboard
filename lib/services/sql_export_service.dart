import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

import '../data/db/database.dart';

/// Dumps the entire SQLite database to a portable `.sql` text file (schema +
/// data as `INSERT` statements) and opens the share sheet so the user can save
/// or send the backup. The output can be replayed with `sqlite3 db.sqlite < f`.
class SqlExportService {
  SqlExportService(this._db);

  final AppDatabase _db;

  /// Builds the dump and opens the system "Save to…" dialog so the user can
  /// download it to a location they pick (e.g. Downloads). Returns the saved
  /// path, or null if the user cancels.
  Future<String?> exportSqlDump() async {
    final sql = await _buildDump();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/mqtt_dash_backup.sql');
    await file.writeAsString(sql);
    return FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        sourceFilePath: file.path,
        fileName: 'mqtt_dash_backup.sql',
      ),
    );
  }

  Future<String> _buildDump() async {
    final out = StringBuffer()
      ..writeln('-- mqtt_dash SQL backup')
      ..writeln('PRAGMA foreign_keys=OFF;')
      ..writeln('BEGIN TRANSACTION;');

    // All user schema objects (skip SQLite internal tables). CREATE TABLE first
    // so the following INSERTs have somewhere to land; indexes/triggers last.
    final schema = await _db
        .customSelect(
          "SELECT type, name, sql FROM sqlite_master "
          "WHERE sql IS NOT NULL AND name NOT LIKE 'sqlite_%'",
        )
        .get();

    final tables = <String>[];
    final trailing = <String>[]; // indexes / triggers emitted after the data
    for (final row in schema) {
      final type = row.read<String>('type');
      final createSql = row.read<String>('sql');
      if (type == 'table') {
        out.writeln('$createSql;');
        tables.add(row.read<String>('name'));
      } else {
        trailing.add('$createSql;');
      }
    }

    for (final table in tables) {
      final rows = await _db.customSelect('SELECT * FROM "$table"').get();
      for (final r in rows) {
        final data = r.data;
        if (data.isEmpty) continue;
        final cols = data.keys.map((c) => '"$c"').join(', ');
        final vals = data.keys.map((k) => _literal(data[k])).join(', ');
        out.writeln('INSERT INTO "$table" ($cols) VALUES ($vals);');
      }
    }

    for (final stmt in trailing) {
      out.writeln(stmt);
    }

    out.writeln('COMMIT;');
    return out.toString();
  }

  /// Renders a column value as a SQL literal.
  static String _literal(Object? value) {
    if (value == null) return 'NULL';
    if (value is int || value is double) return value.toString();
    if (value is bool) return value ? '1' : '0';
    if (value is Uint8List) {
      final hex = value
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
      return "X'$hex'";
    }
    // Text: single-quote and escape embedded quotes.
    return "'${value.toString().replaceAll("'", "''")}'";
  }
}
