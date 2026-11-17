import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/models/settings_model.dart';
import 'package:exam_app/core/utils/result.dart';

abstract interface class SettingsRepo {
  FutureResult<SettingsModel> getSettings();

  FutureResultVoid completeOnboarding({
    required String examName,
    required DateTime examDate,
    required DailyGoal dailyGoal,
    String userName = '',
  });
}
