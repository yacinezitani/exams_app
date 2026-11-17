import 'package:exam_app/core/models/daily_goal.dart';
import 'package:flutter/foundation.dart';

@immutable
class SettingsModel {
  final String? userName;
  final String? examName;
  final DateTime? examDate;
  final DailyGoal dailyGoal;
  final bool isOnboarded;

  const SettingsModel({
    this.userName,
    this.examName,
    this.examDate,
    this.dailyGoal = DailyGoal.recommended,
    this.isOnboarded = false,
  });
}
