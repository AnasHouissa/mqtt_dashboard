import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/db/database.dart';
import '../utils/number_format.dart';
import 'alert_engine.dart';

/// Column headers for an alert export, resolved by the caller so this service
/// stays free of localization.
typedef AlertExportHeaders = ({
  String date,
  String time,
  String level,
  String alert,
  String metric,
  String value,
  String threshold,
  String acknowledgedAt,
});

/// Renders one event's threshold cell: `≥ 20` for an analog condition, or the
/// state name (`On`) for an on/off one, whose stored threshold is meaningless.
/// [symbol] is the operator renderer, so the PDF can pass an ASCII variant.
String _thresholdCell(
  AlertEvent event,
  Map<AlertComparison, String> stateLabels,
  String Function(AlertComparison) symbol,
  String locale,
) {
  if (isBooleanComparison(event.comparison)) {
    return stateLabels[event.comparison] ?? event.comparison.name;
  }
  return '${symbol(event.comparison)} '
      '${formatMetricValue(event.threshold, locale)}';
}

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

  /// Writes a CSV of fired alerts and opens the system save dialog. Same
  /// semicolon separator as the readings export, so French comma-decimals
  /// never collide with the field separator. [levelLabels] supplies the
  /// localized severity names.
  Future<void> exportAlertsCsv({
    required String baseName,
    required List<AlertEvent> events,
    required AlertExportHeaders headers,
    required Map<AlertLevel, String> levelLabels,
    required Map<AlertComparison, String> stateLabels,
    required String locale,
  }) async {
    final rows = <List<dynamic>>[
      [
        headers.date,
        headers.time,
        headers.level,
        headers.alert,
        headers.metric,
        headers.value,
        headers.threshold,
        headers.acknowledgedAt,
      ],
      for (final e in events)
        [
          _dateOnlyFmt.format(e.triggeredAt),
          _timeOnlyFmt.format(e.triggeredAt),
          levelLabels[e.level] ?? e.level.name,
          e.ruleName,
          e.metricName,
          formatMetricValue(e.value, locale),
          _thresholdCell(e, stateLabels, comparisonSymbol, locale),
          e.acknowledgedAt == null ? '' : _dateFmt.format(e.acknowledgedAt!),
        ],
    ];
    final csv = const ListToCsvConverter(fieldDelimiter: ';').convert(rows);

    final file = await _writeFile('${_safe(baseName)}.csv', csv);
    await _saveToDevice(file, '${_safe(baseName)}.csv');
  }

  /// Builds a PDF table of fired alerts and opens the system save dialog.
  /// Landscape, because an alert row carries more columns than a reading.
  Future<void> exportAlertsPdf({
    required String baseName,
    required String title,
    required List<AlertEvent> events,
    required AlertExportHeaders headers,
    required Map<AlertLevel, String> levelLabels,
    required Map<AlertComparison, String> stateLabels,
    required String locale,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(title)),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: [
              headers.date,
              headers.level,
              headers.alert,
              headers.metric,
              headers.value,
              headers.threshold,
              headers.acknowledgedAt,
            ],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: const pw.TextStyle(fontSize: 9),
            data: [
              for (final e in events)
                [
                  _dateFmt.format(e.triggeredAt),
                  levelLabels[e.level] ?? e.level.name,
                  e.ruleName,
                  e.metricName,
                  formatMetricValue(e.value, locale),
                  // ASCII operator: Helvetica has no `≥`/`≤` glyph and would
                  // drop it, leaving a bare threshold with no direction.
                  _thresholdCell(
                      e, stateLabels, comparisonSymbolAscii, locale),
                  e.acknowledgedAt == null
                      ? ''
                      : _dateFmt.format(e.acknowledgedAt!),
                ],
            ],
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    final file = await _writeBytes('${_safe(baseName)}.pdf', bytes);
    await _saveToDevice(file, '${_safe(baseName)}.pdf');
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
