/// Consecutive studied days ending today. If today has no activity yet the
/// count runs back from yesterday, so a pending today never breaks a streak.
/// [days] and [today] must be date-only.
int streakLength(Set<DateTime> days, DateTime today) {
  var cursor = days.contains(today)
      ? today
      : DateTime(today.year, today.month, today.day - 1);
  var length = 0;
  while (days.contains(cursor)) {
    length++;
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }
  return length;
}
