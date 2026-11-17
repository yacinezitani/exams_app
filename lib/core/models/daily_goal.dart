import 'package:exam_app/core/domain/daily_plan_use_case.dart';

enum DailyGoal {
  light(10),
  steady(20),
  focused(30),
  intense(50);

  const DailyGoal(this.cards);

  final int cards;

  static const DailyGoal recommended = DailyGoal.focused;

  /// Study time estimate: two cards per minute.
  int get minutes => estimateMinutes(cards);

  static DailyGoal fromCards(int? cards) => DailyGoal.values.firstWhere(
        (g) => g.cards == cards,
        orElse: () => recommended,
      );
}
