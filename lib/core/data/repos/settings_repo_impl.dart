import 'package:exam_app/core/data/repos/settings_repo.dart';
import 'package:exam_app/core/errors/failures.dart';
import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/models/settings_model.dart';
import 'package:exam_app/core/utils/date_extensions.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepoImpl implements SettingsRepo {
  final SharedPreferences _prefs;
  SettingsRepoImpl(this._prefs);

  static const _kUserName = 'user_name';
  static const _kExamName = 'exam_name';
  static const _kExamDate = 'exam_date';
  static const _kDailyGoal = 'daily_goal';
  static const _kOnboarded = 'onboarding_done';

  @override
  FutureResult<SettingsModel> getSettings() async {
    try {
      final rawDate = _prefs.getString(_kExamDate);
      return Ok(SettingsModel(
        userName: _prefs.getString(_kUserName),
        examName: _prefs.getString(_kExamName),
        // tryParse: a corrupt value degrades to "no date" instead of throwing.
        examDate: rawDate == null ? null : DateTime.tryParse(rawDate),
        dailyGoal: DailyGoal.fromCards(_prefs.getInt(_kDailyGoal)),
        isOnboarded: _prefs.getBool(_kOnboarded) ?? false,
      ));
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }

  @override
  FutureResultVoid completeOnboarding({
    required String examName,
    required DateTime examDate,
    required DailyGoal dailyGoal,
    String userName = '',
  }) async {
    try {
      final name = userName.trim();
      final saved = [
        // Optional: a blank name clears any previous one.
        name.isEmpty ? await _prefs.remove(_kUserName) : await _prefs.setString(_kUserName, name),
        await _prefs.setString(_kExamName, examName),
        // ISO date, built by hand: DateFormat would use locale digits.
        await _prefs.setString(
            _kExamDate, examDate.dateOnly.toIso8601String().substring(0, 10)),
        await _prefs.setInt(_kDailyGoal, dailyGoal.cards),
        // Written last: a partial failure never marks onboarding as done.
        await _prefs.setBool(_kOnboarded, true),
      ];
      if (saved.contains(false)) {
        return const Err(UnknownFailure('Preferences write failed'));
      }
      return const Ok(null);
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }
}
