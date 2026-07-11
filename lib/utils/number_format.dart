import 'package:intl/intl.dart';

/// Formats a metric value using [locale]'s decimal separator — a comma for
/// French (`23,3`), a dot for English (`23.3`). Shows up to two decimals,
/// dropping trailing zeros (whole numbers show no decimals), and uses no
/// grouping separators so the output stays safe inside a CSV field.
///
/// [locale] is a locale tag such as `fr` or `en` (from
/// `Localizations.localeOf(context).toString()`).
String formatMetricValue(double value, String locale) =>
    NumberFormat('0.##', locale).format(value);
