import 'package:exam_app/core/domain/daily_plan_use_case.dart';
import 'package:exam_app/core/models/daily_goal.dart';
import 'package:flutter_test/flutter_test.dart';

int _perDay(DailyPlan plan) => (plan as PlanActive).cardsPerDay;

void main() {
  test('rounds up: 100 cards over 7 days is 15 a day', () {
    final plan = computeDailyPlan(notMastered: 100, daysLeft: 7, dailyGoal: DailyGoal.light);
    expect(_perDay(plan), 15);
  });

  test('never drops below the daily goal', () {
    final plan = computeDailyPlan(notMastered: 10, daysLeft: 20, dailyGoal: DailyGoal.focused);
    expect(_perDay(plan), 30);
  });

  test('exam today plans a single day instead of dividing by zero', () {
    final plan = computeDailyPlan(notMastered: 80, daysLeft: 0, dailyGoal: DailyGoal.light);
    expect(_perDay(plan), 80);
  });

  test('a past exam has no plan', () {
    final plan = computeDailyPlan(notMastered: 80, daysLeft: -3, dailyGoal: DailyGoal.light);
    expect(plan, isA<PlanExamPassed>());
  });

  test('nothing left to master still honours the goal', () {
    final plan = computeDailyPlan(notMastered: 0, daysLeft: 5, dailyGoal: DailyGoal.steady);
    expect(_perDay(plan), 20);
  });

  test('estimateMinutes is two cards per minute, rounded up', () {
    expect(estimateMinutes(32), 16);
    expect(estimateMinutes(31), 16);
    expect(estimateMinutes(0), 0);
    expect(DailyGoal.focused.minutes, 15);
  });
}
