import 'package:exam_app/core/domain/daily_plan_use_case.dart';
import 'package:exam_app/core/models/deck_summary_model.dart';
import 'package:exam_app/core/models/due_summary_model.dart';
import 'package:flutter/foundation.dart';

enum PlanStatus { done, onTrack, behind }

/// Everything Home renders, derived once per load.
@immutable
class HomeData {
  /// Full timestamp: the greeting depends on the hour.
  final DateTime now;
  final String? userName;
  final String examName;

  /// Null when no valid date is stored; treated like a passed exam.
  final DateTime? examDate;

  /// Negative when the exam is over or unset.
  final int daysLeft;
  final List<DeckSummaryModel> decks;
  final DueSummaryModel due;
  final int streak;
  final Set<DateTime> studyDays;
  final DailyPlan plan;
  final int studiedToday;

  /// 0–1: share of all cards that are mastered.
  final double planProgress;
  final PlanStatus planStatus;

  const HomeData({
    required this.now,
    required this.userName,
    required this.examName,
    required this.examDate,
    required this.daysLeft,
    required this.decks,
    required this.due,
    required this.streak,
    required this.studyDays,
    required this.plan,
    required this.studiedToday,
    required this.planProgress,
    required this.planStatus,
  });

  bool get isEmpty => decks.isEmpty;
}
