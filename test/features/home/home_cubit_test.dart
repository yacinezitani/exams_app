import 'package:bloc_test/bloc_test.dart';
import 'package:exam_app/core/data/repos/card_repo.dart';
import 'package:exam_app/core/data/repos/deck_repo.dart';
import 'package:exam_app/core/data/repos/review_repo.dart';
import 'package:exam_app/core/data/repos/settings_repo.dart';
import 'package:exam_app/core/domain/daily_plan_use_case.dart';
import 'package:exam_app/core/errors/failures.dart';
import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/models/deck_model.dart';
import 'package:exam_app/core/models/deck_summary_model.dart';
import 'package:exam_app/core/models/due_summary_model.dart';
import 'package:exam_app/core/models/settings_model.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:exam_app/features/home/presentation/view_models/home_cubit.dart';
import 'package:exam_app/features/home/presentation/view_models/home_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDeckRepo extends Mock implements DeckRepo {}

class _MockCardRepo extends Mock implements CardRepo {}

class _MockReviewRepo extends Mock implements ReviewRepo {}

class _MockSettingsRepo extends Mock implements SettingsRepo {}

DeckSummaryModel _deck(int cards, int due, int mastered) => DeckSummaryModel(
      deck: DeckModel(
        id: 1,
        name: 'Cell Biology',
        subject: 'Biology',
        color: 0xFF4F46E5,
        createdAt: DateTime(2026, 11, 1),
      ),
      cardCount: cards,
      dueCount: due,
      masteredCount: mastered,
    );

void main() {
  late _MockDeckRepo decks;
  late _MockCardRepo cards;
  late _MockReviewRepo reviews;
  late _MockSettingsRepo settings;
  final now = DateTime(2026, 11, 17, 9, 30);

  setUpAll(() {
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    decks = _MockDeckRepo();
    cards = _MockCardRepo();
    reviews = _MockReviewRepo();
    settings = _MockSettingsRepo();
  });

  void stub({
    List<DeckSummaryModel> deckList = const [],
    Set<DateTime> days = const {},
    int studiedToday = 0,
    SettingsModel? settingsModel,
    bool failReviews = false,
  }) {
    when(() => decks.getDeckSummaries(
          dueBefore: any(named: 'dueBefore'),
          masteredIntervalDays: any(named: 'masteredIntervalDays'),
        )).thenAnswer((_) async => Ok(deckList));
    when(() => cards.getDueSummary(any()))
        .thenAnswer((_) async => const Ok(DueSummaryModel(reviewCount: 20, newCount: 12)));
    when(() => reviews.getStudyDays()).thenAnswer((_) async => failReviews
        ? const Err(DatabaseFailure('disk'))
        : Ok(days));
    when(() => reviews.countStudiedCards(
          start: any(named: 'start'),
          end: any(named: 'end'),
        )).thenAnswer((_) async => Ok(studiedToday));
    when(() => settings.getSettings()).thenAnswer((_) async => Ok(
          settingsModel ??
              SettingsModel(
                userName: 'Amira',
                examName: 'Biology Final',
                examDate: DateTime(2026, 12, 12),
                dailyGoal: DailyGoal.focused,
                isOnboarded: true,
              ),
        ));
  }

  HomeCubit build() => HomeCubit(
        deckRepo: decks,
        cardRepo: cards,
        reviewRepo: reviews,
        settingsRepo: settings,
        now: () => now,
      );

  blocTest<HomeCubit, HomeState>(
    'derives countdown, streak, plan and progress',
    setUp: () => stub(
      deckList: [_deck(48, 12, 24), _deck(36, 9, 12)],
      days: {DateTime(2026, 11, 16), DateTime(2026, 11, 15)},
    ),
    build: build,
    act: (c) => c.load(),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeSuccess>()
          .having((s) => s.data.daysLeft, 'daysLeft', 25)
          .having((s) => s.data.streak, 'streak', 2)
          .having((s) => s.data.due.total, 'due', 32)
          .having((s) => s.data.planProgress, 'progress', closeTo(36 / 84, 1e-9))
          .having((s) => s.data.planStatus, 'status', PlanStatus.onTrack)
          // 48 cards left over 25 days is 2/day, so the 30-card goal wins.
          .having((s) => (s.data.plan as PlanActive).cardsPerDay, 'plan', 30)
          .having((s) => s.data.isEmpty, 'isEmpty', false),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'no decks yields an empty Home with zero progress',
    setUp: stub,
    build: build,
    act: (c) => c.load(),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeSuccess>()
          .having((s) => s.data.isEmpty, 'isEmpty', true)
          .having((s) => s.data.planProgress, 'progress', 0),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'meeting the plan today marks it done',
    setUp: () => stub(deckList: [_deck(48, 12, 24)], studiedToday: 30),
    build: build,
    act: (c) => c.load(),
    verify: (c) => expect(
      (c.state as HomeSuccess).data.planStatus,
      PlanStatus.done,
    ),
  );

  blocTest<HomeCubit, HomeState>(
    'no study yesterday or today is behind',
    setUp: () => stub(deckList: [_deck(48, 12, 24)], days: {DateTime(2026, 11, 10)}),
    build: build,
    act: (c) => c.load(),
    verify: (c) => expect(
      (c.state as HomeSuccess).data.planStatus,
      PlanStatus.behind,
    ),
  );

  blocTest<HomeCubit, HomeState>(
    'a past exam date yields no plan',
    setUp: () => stub(
      deckList: [_deck(10, 1, 0)],
      settingsModel: SettingsModel(examName: 'Old', examDate: DateTime(2026, 11, 1)),
    ),
    build: build,
    act: (c) => c.load(),
    verify: (c) {
      final data = (c.state as HomeSuccess).data;
      expect(data.daysLeft, lessThan(0));
      expect(data.plan, isA<PlanExamPassed>());
    },
  );

  blocTest<HomeCubit, HomeState>(
    'any repo failure becomes HomeFailure',
    setUp: () => stub(failReviews: true),
    build: build,
    act: (c) => c.load(),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeFailure>().having((s) => s.errMessage, 'errMessage', 'disk'),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'a reload keeps content instead of showing the skeleton again',
    setUp: () => stub(deckList: [_deck(5, 1, 0)]),
    build: build,
    act: (c) async {
      await c.load();
      await c.load();
    },
    expect: () => [isA<HomeLoading>(), isA<HomeSuccess>(), isA<HomeSuccess>()],
  );
}
