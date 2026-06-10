import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../data/db/database.dart';

/// Builds CSV / PDF files from readings and shares them.
class ExportService {
  static final _dateFmt = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// Writes a CSV file and opens the share sheet.
  Future<void> exportCsv({
    required String metricName,
    required List<Reading> readings,
    required String timestampHeader,
    required String valueHeader,
  }) async {
    final rows = <List<dynamic>>[
      [timestampHeader, valueHeader],
      for (final r in readings) [_dateFmt.format(r.timestamp), r.value],
    ];
    final csv = const ListToCsvConverter().convert(rows);

    final file = await _writeFile('${_safe(metricName)}.csv', csv);
    await Share.shareXFiles([XFile(file.path)], subject: '$metricName CSV');
  }

  /// Builds a PDF table and opens the share sheet.
  Future<void> exportPdf({
    required String metricName,
    required String title,
    required List<Reading> readings,
    required String timestampHeader,
    required String valueHeader,
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
                [_dateFmt.format(r.timestamp), r.value.toString()],
            ],
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    final file = await _writeBytes('${_safe(metricName)}.pdf', bytes);
    await Share.shareXFiles([XFile(file.path)], subject: '$metricName PDF');
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

  static String _safe(String name) =>
      name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
}
