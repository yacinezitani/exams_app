extension DateOnlyX on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  /// Whole calendar days from this date to [other]. Computed in UTC so a DST
  /// change between the two dates never causes an off-by-one.
  int daysUntil(DateTime other) => DateTime.utc(other.year, other.month, other.day)
      .difference(DateTime.utc(year, month, day))
      .inDays;
}
