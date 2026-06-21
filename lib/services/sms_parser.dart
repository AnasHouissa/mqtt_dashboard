import '../data/db/database.dart' show SmsValueMode;

/// One parsed `TOPIC [ VALUE ]` line of an SMS, with the optional `Min .. Max`
/// threshold range that preceded it (inline or on its own line).
class SmsTopicLine {
  const SmsTopicLine({
    required this.topic,
    required this.rawValue,
    this.min,
    this.max,
  });

  /// The topic label, e.g. `WATER ALERT`, `TEMP ALERT`, `DOOR ALERT`.
  final String topic;

  /// The raw bracket contents, e.g. `IN1, IN2, IN4`, `21.62`, `Err 111`, `OK`.
  final String rawValue;

  /// Threshold bounds from a `Min .. Max` prefix (TEMP messages); null if absent.
  final double? min;
  final double? max;

  @override
  String toString() =>
      'SmsTopicLine(topic: $topic, rawValue: $rawValue, min: $min, max: $max)';
}

/// The result of parsing a full SMS body: the station [name] (first line) and
/// the topic lines beneath it.
class SmsParseResult {
  const SmsParseResult({required this.name, required this.lines});

  final String name;
  final List<SmsTopicLine> lines;

  bool get isEmpty => name.isEmpty || lines.isEmpty;
}

/// Parses the device SMS format and converts bracket values to chartable
/// numbers. Pure and side-effect free so it is fully unit-testable.
///
/// Message shape (line breaks may vary; the `Min .. Max` range may sit inline
/// before the topic or on its own line):
/// ```
/// <NAME>
/// [Min <n> - Max <n> | Min <n> | Max <n>] <TOPIC> [ <VALUE> ]
/// ```
class SmsParser {
  SmsParser._();

  /// Matches a `Min <n> [-|] Max <n>` threshold range. The separator is `-`
  /// (positive bounds) or `|` (used in the negative-bound examples).
  static final RegExp _rangeAtStart = RegExp(
    r'^\s*Min\s*(-?\d+(?:\.\d+)?)\s*[-|]\s*Max\s*(-?\d+(?:\.\d+)?)\s*',
    caseSensitive: false,
  );
  static final RegExp _rangeWhole = RegExp(
    r'^\s*Min\s*(-?\d+(?:\.\d+)?)\s*[-|]\s*Max\s*(-?\d+(?:\.\d+)?)\s*$',
    caseSensitive: false,
  );

  /// The trailing `[ ... ]` carrying the value.
  static final RegExp _bracket = RegExp(r'\[([^\]]*)\]\s*$');

  /// First signed/decimal number anywhere in a string.
  static final RegExp _firstNumber = RegExp(r'-?\d+(?:\.\d+)?');

  /// An active input token such as `IN1`, `IN12`.
  static final RegExp _inputToken = RegExp(r'^IN\d+$', caseSensitive: false);

  static const _clearedTokens = {'OK', 'NONE', 'CLEAR', ''};

  static SmsParseResult parse(String body) {
    final rawLines = body
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (rawLines.isEmpty) {
      return const SmsParseResult(name: '', lines: []);
    }

    final name = rawLines.first;
    final lines = <SmsTopicLine>[];
    double? pendingMin;
    double? pendingMax;

    for (final line in rawLines.skip(1)) {
      final bracket = _bracket.firstMatch(line);
      if (bracket == null) {
        // No value bracket: this may be a standalone `Min .. Max` range line
        // that applies to the next topic line.
        final range = _rangeWhole.firstMatch(line);
        if (range != null) {
          pendingMin = double.tryParse(range.group(1)!);
          pendingMax = double.tryParse(range.group(2)!);
        }
        continue;
      }

      final rawValue = bracket.group(1)!.trim();
      var left = line.substring(0, bracket.start);

      double? min = pendingMin;
      double? max = pendingMax;
      final inlineRange = _rangeAtStart.firstMatch(left);
      if (inlineRange != null) {
        min = double.tryParse(inlineRange.group(1)!);
        max = double.tryParse(inlineRange.group(2)!);
        left = left.substring(inlineRange.end);
      }

      final topic = left.trim();
      if (topic.isEmpty) continue; // a bracket with no preceding topic

      lines.add(SmsTopicLine(
        topic: topic,
        rawValue: rawValue,
        min: min,
        max: max,
      ));
      // A range applies only to the topic line it precedes.
      pendingMin = null;
      pendingMax = null;
    }

    return SmsParseResult(name: name, lines: lines);
  }

  /// Converts a raw bracket value to a numeric reading for the given [mode].
  /// Returns null when nothing sensible can be extracted.
  static double? toValue(String rawValue, SmsValueMode mode) {
    final v = rawValue.trim();
    switch (mode) {
      case SmsValueMode.number:
        final m = _firstNumber.firstMatch(v);
        return m == null ? null : double.tryParse(m.group(0)!);
      case SmsValueMode.activeCount:
        return v
            .split(',')
            .map((t) => t.trim())
            .where((t) => !_clearedTokens.contains(t.toUpperCase()))
            .length
            .toDouble();
      case SmsValueMode.presence:
        return _clearedTokens.contains(v.toUpperCase()) ? 0 : 1;
    }
  }

  /// Best-guess value mode for a sample bracket value, used as the default when
  /// the user adds a metric. A pure number -> [SmsValueMode.number]; an input
  /// list / `OK` -> [SmsValueMode.activeCount]; otherwise number (e.g. an error
  /// code like `Err 111`).
  static SmsValueMode detectMode(String rawValue) {
    final v = rawValue.trim();
    if (RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(v)) return SmsValueMode.number;
    final upper = v.toUpperCase();
    final looksLikeInputs = v.contains(',') ||
        upper == 'OK' ||
        upper == 'NONE' ||
        v.split(',').any((t) => _inputToken.hasMatch(t.trim()));
    return looksLikeInputs ? SmsValueMode.activeCount : SmsValueMode.number;
  }
}
