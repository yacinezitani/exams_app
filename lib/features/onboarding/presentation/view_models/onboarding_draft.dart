import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/utils/date_extensions.dart';
import 'package:flutter/foundation.dart';

/// Answers collected across the three onboarding steps.
@immutable
class OnboardingDraft {
  final String userName;
  final String examName;
  final DateTime? examDate;
  final DailyGoal dailyGoal;

  /// Date-only "today", pinned at cubit creation so every screen agrees.
  final DateTime today;

  const OnboardingDraft({
    required this.today,
    this.userName = '',
    this.examName = '',
    this.examDate,
    this.dailyGoal = DailyGoal.recommended,
  });

  /// First selectable exam day.
  DateTime get firstSelectableDate => today.add(const Duration(days: 1)).dateOnly;

  bool get isExamStepValid => examName.trim().isNotEmpty && examDate != null;

  int get daysLeft => examDate == null ? 0 : today.daysUntil(examDate!);

  int get estimatedReviews => dailyGoal.cards * daysLeft;

  OnboardingDraft copyWith({
    String? userName,
    String? examName,
    DateTime? examDate,
    DailyGoal? dailyGoal,
  }) =>
      OnboardingDraft(
        today: today,
        userName: userName ?? this.userName,
        examName: examName ?? this.examName,
        examDate: examDate ?? this.examDate,
        dailyGoal: dailyGoal ?? this.dailyGoal,
      );
}
