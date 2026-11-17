import 'package:exam_app/core/data/repos/settings_repo_impl.dart';
import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsRepoImpl> _repo([Map<String, Object> initial = const {}]) async {
  SharedPreferences.setMockInitialValues(initial);
  return SettingsRepoImpl(await SharedPreferences.getInstance());
}

void main() {
  test('defaults to not onboarded', () async {
    final result = await (await _repo()).getSettings();
    final s = result.valueOrNull!;
    expect(s.isOnboarded, isFalse);
    expect(s.examName, isNull);
    expect(s.examDate, isNull);
    expect(s.dailyGoal, DailyGoal.recommended);
  });

  test('completeOnboarding round-trips', () async {
    final repo = await _repo();
    final saved = await repo.completeOnboarding(
      examName: 'Biology Final',
      examDate: DateTime(2026, 12, 12, 15),
      dailyGoal: DailyGoal.intense,
      userName: ' Amira ',
    );
    expect(saved.isOk, isTrue);

    final s = (await repo.getSettings()).valueOrNull!;
    expect(s.isOnboarded, isTrue);
    expect(s.userName, 'Amira');
    expect(s.examName, 'Biology Final');
    expect(s.examDate, DateTime(2026, 12, 12));
    expect(s.dailyGoal, DailyGoal.intense);
  });

  test('blank name clears a previously stored name', () async {
    final repo = await _repo({'user_name': 'Old'});
    await repo.completeOnboarding(
      examName: 'Final',
      examDate: DateTime(2026, 12, 12),
      dailyGoal: DailyGoal.light,
    );
    expect((await repo.getSettings()).valueOrNull!.userName, isNull);
  });

  test('corrupt date degrades to null instead of failing', () async {
    final repo = await _repo({'exam_date': 'not-a-date', 'onboarding_done': true});
    final result = await repo.getSettings();
    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.examDate, isNull);
  });

  test('unknown stored goal falls back to the recommended one', () async {
    final repo = await _repo({'daily_goal': 7});
    expect((await repo.getSettings()).valueOrNull!.dailyGoal, DailyGoal.recommended);
  });
}
