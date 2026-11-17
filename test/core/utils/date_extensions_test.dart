import 'package:exam_app/core/utils/date_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daysUntil counts calendar days', () {
    expect(DateTime(2026, 11, 17).daysUntil(DateTime(2026, 12, 12)), 25);
  });

  test('daysUntil is 0 on the same day regardless of time', () {
    expect(DateTime(2026, 11, 17, 23).daysUntil(DateTime(2026, 11, 17, 1)), 0);
  });

  test('daysUntil is exact across a DST change', () {
    expect(DateTime(2026, 3, 20).daysUntil(DateTime(2026, 4, 5)), 16);
    expect(DateTime(2026, 10, 20).daysUntil(DateTime(2026, 11, 5)), 16);
  });

  test('daysUntil is negative for past dates', () {
    expect(DateTime(2026, 11, 17).daysUntil(DateTime(2026, 11, 10)), -7);
  });
}
