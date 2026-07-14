import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/db/database.dart';
import '../utils/number_format.dart';

/// Builds CSV / PDF files from readings and shares them.
class ExportService {
  static final _dateFmt = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final _dateOnlyFmt = DateFormat('yyyy-MM-dd');
  static final _timeOnlyFmt = DateFormat('HH:mm:ss');

  /// Writes a CSV file and opens the share sheet. Emits `Date;Time;Value`
  /// columns. Values use [locale]'s decimal separator; a semicolon separates
  /// fields so a French comma-decimal (`23,3`) never collides with the field
  /// separator.
  Future<void> exportCsv({
    required String metricName,
    required List<Reading> readings,
    required String dateHeader,
    required String timeHeader,
    required String valueHeader,
    required String locale,
  }) async {
    final rows = <List<dynamic>>[
      [dateHeader, timeHeader, valueHeader],
      for (final r in readings)
        [
          _dateOnlyFmt.format(r.timestamp),
          _timeOnlyFmt.format(r.timestamp),
          formatMetricValue(r.value, locale),
        ],
    ];
    final csv = const ListToCsvConverter(fieldDelimiter: ';').convert(rows);

    final file = await _writeFile('${_safe(metricName)}.csv', csv);
    await _saveToDevice(file, '${_safe(metricName)}.csv');
  }

  /// Builds a PDF table and opens the share sheet. Values use [locale]'s
  /// decimal separator.
  Future<void> exportPdf({
    required String metricName,
    required String title,
    required List<Reading> readings,
    required String timestampHeader,
    required String valueHeader,
    required String locale,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(title)),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: [timestampHeader, valueHeader],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            data: [
              for (final r in readings)
                [_dateFmt.format(r.timestamp), formatMetricValue(r.value, locale)],
            ],
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    final file = await _writeBytes('${_safe(metricName)}.pdf', bytes);
    await _saveToDevice(file, '${_safe(metricName)}.pdf');
  }

  Future<File> _writeFile(String name, String contents) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    return file.writeAsString(contents);
  }

  Future<File> _writeBytes(String name, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    return file.writeAsBytes(bytes);
  }

  /// Opens the system "Save to…" dialog so the user can download [file] to a
  /// location they pick (e.g. Downloads). Returns null if they cancel.
  static Future<String?> _saveToDevice(File file, String fileName) {
    return FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        sourceFilePath: file.path,
        fileName: fileName,
      ),
    );
  }

  static String _safe(String name) =>
      name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
}
