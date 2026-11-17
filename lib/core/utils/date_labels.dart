import 'package:intl/intl.dart';

/// Localized date labels that always render day and year digits as Latin
/// numerals, so they match the digits inside ARB strings in every locale.
abstract final class DateLabels {
  /// "Sat 12 Dec"
  static String shortDate(String locale, DateTime d) =>
      '${DateFormat.E(locale).format(d)} ${_dayMonth(locale, d)}';

  /// "12 Dec"
  static String dayMonth(String locale, DateTime d) => _dayMonth(locale, d);

  /// "December 2026"
  static String monthYear(String locale, DateTime d) =>
      '${DateFormat.MMMM(locale).format(d)} ${d.year}';

  /// "Saturday 12 December 2026"
  static String fullDate(String locale, DateTime d) =>
      '${DateFormat.EEEE(locale).format(d)} ${d.day} '
      '${DateFormat.MMMM(locale).format(d)} ${d.year}';

  static String _dayMonth(String locale, DateTime d) =>
      '${d.day} ${DateFormat.MMM(locale).format(d)}';

  /// "Tuesday"
  static String weekdayName(String locale, DateTime d) =>
      DateFormat.EEEE(locale).format(d);

  /// "17 November"
  static String dayMonthLong(String locale, DateTime d) =>
      '${d.day} ${DateFormat.MMMM(locale).format(d)}';
}
