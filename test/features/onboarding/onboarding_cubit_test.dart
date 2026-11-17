import 'package:bloc_test/bloc_test.dart';
import 'package:exam_app/core/data/repos/settings_repo.dart';
import 'package:exam_app/core/errors/failures.dart';
import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:exam_app/features/onboarding/presentation/view_models/onboarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements SettingsRepo {}

void main() {
  late _MockRepo repo;
  final today = DateTime(2026, 11, 17, 18);

  setUpAll(() => registerFallbackValue(DailyGoal.focused));
  setUpAll(() => registerFallbackValue(DateTime(2026)));
  setUp(() => repo = _MockRepo());

  OnboardingCubit build() => OnboardingCubit(repo, now: () => today);

  void stubComplete(Result<void, Failure> result) => when(
        () => repo.completeOnboarding(
          examName: any(named: 'examName'),
          examDate: any(named: 'examDate'),
          dailyGoal: any(named: 'dailyGoal'),
          userName: any(named: 'userName'),
        ),
      ).thenAnswer((_) async => result);

  test('starts with the recommended goal and a date-only today', () {
    final draft = build().state.draft;
    expect(draft.dailyGoal, DailyGoal.focused);
    expect(draft.today, DateTime(2026, 11, 17));
    expect(draft.isExamStepValid, isFalse);
  });

  test('exam step needs a non-blank name and a date', () {
    final cubit = build()..setExamName('   ');
    cubit.setExamDate(DateTime(2026, 12, 12));
    expect(cubit.state.draft.isExamStepValid, isFalse);
    cubit.setExamName('Biology Final');
    expect(cubit.state.draft.isExamStepValid, isTrue);
  });

  test('30 cards/day × 25 days = 750 estimated reviews', () {
    final cubit = build()..setExamDate(DateTime(2026, 12, 12, 9));
    expect(cubit.state.draft.daysLeft, 25);
    expect(cubit.state.draft.estimatedReviews, 750);
    cubit.setDailyGoal(DailyGoal.light);
    expect(cubit.state.draft.estimatedReviews, 250);
  });

  test('first selectable date is tomorrow', () {
    expect(build().state.draft.firstSelectableDate, DateTime(2026, 11, 18));
  });

  blocTest<OnboardingCubit, OnboardingState>(
    'submit saves trimmed name, then completes',
    setUp: () => stubComplete(const Ok(null)),
    build: build,
    seed: () => OnboardingSuccess(build().state.draft.copyWith(
          userName: ' Amira ',
          examName: '  Biology Final ',
          examDate: DateTime(2026, 12, 12),
        )),
    act: (c) => c.submit(),
    expect: () => [isA<OnboardingLoading>(), isA<OnboardingComplete>()],
    verify: (_) => verify(() => repo.completeOnboarding(
          examName: 'Biology Final',
          examDate: DateTime(2026, 12, 12),
          dailyGoal: DailyGoal.focused,
          userName: 'Amira',
        )).called(1),
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'submit failure keeps the draft',
    setUp: () => stubComplete(const Err(UnknownFailure('boom'))),
    build: build,
    seed: () => OnboardingSuccess(build().state.draft.copyWith(
          examName: 'Biology Final',
          examDate: DateTime(2026, 12, 12),
        )),
    act: (c) => c.submit(),
    expect: () => [
      isA<OnboardingLoading>(),
      isA<OnboardingFailure>()
          .having((s) => s.errMessage, 'errMessage', 'boom')
          .having((s) => s.draft.examName, 'draft kept', 'Biology Final'),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'submit does nothing while the exam step is invalid',
    build: build,
    act: (c) => c.submit(),
    expect: () => <OnboardingState>[],
  );
}
