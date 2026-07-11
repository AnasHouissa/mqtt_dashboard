import 'package:drift/drift.dart' show Value;

import '../data/db/database.dart';
import '../data/repositories/metric_repository.dart';
import '../data/repositories/reading_repository.dart';
import '../data/repositories/sms_message_repository.dart';
import '../data/repositories/sms_source_repository.dart';
import 'sms_parser.dart';
import 'tn_phone.dart';

/// Parses one received SMS and persists any matching values as readings into
/// [db], then logs the message to the raw inbox. Shared by the foreground
/// ingestion controller ([SmsIngestionController]) and the background-isolate
/// handler (`smsBackgroundHandler`) so both behave identically.
///
/// Returns the number of readings created. A message from an untracked number
/// yields 0 and is not logged at all (matching the original behaviour).
Future<int> ingestSms(
  AppDatabase db, {
  required String sender,
  required String body,
  required DateTime timestamp,
}) async {
  final sources = await SmsSourceRepository(db).getAll();
  final source = _matchSource(sources, sender);
  if (source == null) return 0; // not from a tracked number — ignore entirely

  final result = SmsParser.parse(body);
  final metricRepo = MetricRepository(db);
  final readingRepo = ReadingRepository(db);

  var readingsCreated = 0;
  SmsParseStatus status;
  if (result.isEmpty) {
    status = SmsParseStatus.error;
  } else {
    final metrics = await metricRepo.getForSmsSource(source.id);
    for (final line in result.lines) {
      final metric = _matchMetric(metrics, result.name, line.topic);
      if (metric == null) continue;
      // Value mode is always auto-detected from the message (the manual
      // per-metric mode was removed from the UI).
      final mode = SmsParser.detectMode(line.rawValue);
      final value = SmsParser.toValue(line.rawValue, mode);
      if (value == null) continue;
      await readingRepo.insert(metric.id, value, timestamp, raw: line.rawValue);
      readingsCreated++;
      await _maybeSeedRange(metricRepo, metric, line);
    }
    status = readingsCreated > 0
        ? SmsParseStatus.matched
        : SmsParseStatus.unmatched;
  }

  await SmsMessageRepository(db).insert(
    smsSourceId: source.id,
    sender: sender,
    body: body,
    receivedAt: timestamp,
    status: status,
    readingsCreated: readingsCreated,
  );
  return readingsCreated;
}

/// Matches a sender address to a source by its 8-digit subscriber number,
/// tolerating +216 / 00216 / bare-local / spaced sender formats.
SmsSource? _matchSource(List<SmsSource> sources, String sender) {
  final key = TnPhone.matchKey(sender);
  if (key == null) return null;
  for (final src in sources) {
    if (TnPhone.matchKey(src.phoneNumber) == key) return src;
  }
  return null;
}

Metric? _matchMetric(List<Metric> metrics, String name, String topic) {
  final n = name.trim().toLowerCase();
  final t = topic.trim().toLowerCase();
  for (final m in metrics) {
    if (m.name.trim().toLowerCase() == n &&
        m.topic.trim().toLowerCase() == t) {
      return m;
    }
  }
  return null;
}

/// Auto-populate a metric's chart bounds from a `Min .. Max` prefix the first
/// time we see one (only when the user hasn't set bounds themselves).
Future<void> _maybeSeedRange(
  MetricRepository repo,
  Metric metric,
  SmsTopicLine line,
) async {
  if (line.min == null || line.max == null) return;
  if (metric.minValue != null || metric.maxValue != null) return;
  await repo.update(
    metric.copyWith(
      minValue: Value(line.min),
      maxValue: Value(line.max),
    ),
  );
}
