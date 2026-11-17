import 'package:exam_app/core/models/daily_goal.dart';
import 'package:flutter/foundation.dart';

/// A card counts as mastered once its review interval reaches this many days.
const int kMasteredIntervalDays = 7;

/// Study time estimate: two cards per minute.
int estimateMinutes(int cards) => (cards / 2).ceil();

@immutable
sealed class DailyPlan {
  const DailyPlan();
}

/// The exam date is before today.
final class PlanExamPassed extends DailyPlan {
  const PlanExamPassed();
}

final class PlanActive extends DailyPlan {
  final int cardsPerDay;
  const PlanActive(this.cardsPerDay);
}

/// `ceil(notMastered / max(daysLeft, 1))`, never below the user's goal.
/// An exam today still plans one day; a past exam has no plan.
DailyPlan computeDailyPlan({
  required int notMastered,
  required int daysLeft,
  required DailyGoal dailyGoal,
}) {
  if (daysLeft < 0) return const PlanExamPassed();
  final days = daysLeft < 1 ? 1 : daysLeft;
  final needed = (notMastered / days).ceil();
  return PlanActive(needed > dailyGoal.cards ? needed : dailyGoal.cards);
}
