/// Tunisian phone-number helpers shared by SMS source creation and the incoming
/// SMS matcher. A Tunisian subscriber number is 8 digits; its E.164 form is
/// `+216` followed by those 8 digits.
class TnPhone {
  TnPhone._();

  /// Canonicalises user input to `+216XXXXXXXX`. Tolerates spaces/dashes and
  /// accepts the `+216…`, `00216…`, or bare 8-digit forms. Returns null if the
  /// input is not a valid Tunisian number.
  ///
  /// Examples (all -> `+21655101214`):
  ///   `+21655101214`, `+216 55 101 214`, `0021655101214`, `55101214`.
  static String? normalize(String raw) {
    var d = raw.replaceAll(RegExp(r'\D'), '');
    if (d.startsWith('00216')) {
      d = d.substring(5);
    } else if (d.length == 11 && d.startsWith('216')) {
      d = d.substring(3);
    }
    return RegExp(r'^\d{8}$').hasMatch(d) ? '+216$d' : null;
  }

  /// The key used to match an incoming sender address to a stored source: the
  /// last 8 digits (the subscriber number), ignoring any country-code prefix and
  /// all spacing. Because stored numbers are always canonical `+216XXXXXXXX`,
  /// this matches whether the network delivers the sender as `+216…`, `00216…`,
  /// or the bare local number. Returns null when fewer than 8 digits are present
  /// (e.g. an alphanumeric sender id), which never matches.
  static String? matchKey(String raw) {
    final d = raw.replaceAll(RegExp(r'\D'), '');
    return d.length >= 8 ? d.substring(d.length - 8) : null;
  }
}
