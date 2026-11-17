import 'package:exam_app/core/domain/study_streak.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 11, 17);
  DateTime ago(int n) => DateTime(2026, 11, 17 - n);

  test('empty history is a zero streak', () {
    expect(streakLength({}, today), 0);
  });

  test('counts today and the days before it', () {
    expect(streakLength({today, ago(1), ago(2)}, today), 3);
  });

  test('a pending today does not break yesterday’s streak', () {
    expect(streakLength({ago(1), ago(2), ago(3)}, today), 3);
  });

  test('a gap ends the streak', () {
    expect(streakLength({today, ago(1), ago(3), ago(4)}, today), 2);
  });

  test('last studied two days ago means no streak', () {
    expect(streakLength({ago(2), ago(3)}, today), 0);
  });

  test('crosses a month boundary', () {
    final firstOfMonth = DateTime(2026, 12, 1);
    expect(
      streakLength({firstOfMonth, DateTime(2026, 11, 30), DateTime(2026, 11, 29)}, firstOfMonth),
      3,
    );
  });
}
