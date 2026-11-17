import 'package:exam_app/core/data/repos/card_repo.dart';
import 'package:exam_app/core/data/repos/deck_repo.dart';
import 'package:exam_app/core/data/repos/review_repo.dart';
import 'package:exam_app/core/data/repos/settings_repo.dart';
import 'package:exam_app/core/domain/daily_plan_use_case.dart';
import 'package:exam_app/core/domain/study_streak.dart';
import 'package:exam_app/core/models/deck_summary_model.dart';
import 'package:exam_app/core/models/due_summary_model.dart';
import 'package:exam_app/core/models/settings_model.dart';
import 'package:exam_app/core/utils/date_extensions.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:exam_app/features/home/presentation/view_models/home_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DeckRepo _deckRepo;
  final CardRepo _cardRepo;
  final ReviewRepo _reviewRepo;
  final SettingsRepo _settingsRepo;
  final DateTime Function() _now;

  /// [now] is injectable so tests can pin the clock.
  HomeCubit({
    required this._deckRepo,
    required this._cardRepo,
    required this._reviewRepo,
    required this._settingsRepo,
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        super(const HomeInitial());

  Future<void> load() async {
    if (isClosed) return;
    // Reloads keep the current content on screen instead of flashing a skeleton.
    if (state is! HomeSuccess) emit(const HomeLoading());

    final now = _now();
    final today = now.dateOnly;
    final tomorrow = DateTime(today.year, today.month, today.day + 1);

    final results = await (
      _deckRepo.getDeckSummaries(
        dueBefore: tomorrow,
        masteredIntervalDays: kMasteredIntervalDays,
      ),
      _cardRepo.getDueSummary(tomorrow),
      _reviewRepo.getStudyDays(),
      _reviewRepo.countStudiedCards(start: today, end: tomorrow),
      _settingsRepo.getSettings(),
    ).wait;
    if (isClosed) return;

    switch (results) {
      case (
          Ok(value: final decks),
          Ok(value: final due),
          Ok(value: final days),
          Ok(value: final studied),
          Ok(value: final settings),
        ):
        emit(HomeSuccess(_build(now, decks, due, days, studied, settings)));
      default:
        final (a, b, c, d, e) = results;
        final failure = [a.errorOrNull, b.errorOrNull, c.errorOrNull, d.errorOrNull, e.errorOrNull]
            .nonNulls
            .firstOrNull;
        emit(HomeFailure(failure?.error ?? ''));
    }
  }

  HomeData _build(
    DateTime now,
    List<DeckSummaryModel> decks,
    DueSummaryModel due,
    Set<DateTime> studyDays,
    int studiedToday,
    SettingsModel settings,
  ) {
    final today = now.dateOnly;
    final examDate = settings.examDate;
    final daysLeft = examDate == null ? -1 : today.daysUntil(examDate);
    final totalCards = decks.fold<int>(0, (sum, d) => sum + d.cardCount);
    final mastered = decks.fold<int>(0, (sum, d) => sum + d.masteredCount);
    final plan = computeDailyPlan(
      notMastered: totalCards - mastered,
      daysLeft: daysLeft,
      dailyGoal: settings.dailyGoal,
    );
    final yesterday = DateTime(today.year, today.month, today.day - 1);

    return HomeData(
      now: now,
      userName: settings.userName,
      examName: settings.examName ?? '',
      examDate: examDate,
      daysLeft: daysLeft,
      decks: decks,
      due: due,
      streak: streakLength(studyDays, today),
      studyDays: studyDays,
      plan: plan,
      studiedToday: studiedToday,
      planProgress: totalCards == 0 ? 0 : mastered / totalCards,
      planStatus: switch (plan) {
        PlanActive(:final cardsPerDay) when studiedToday >= cardsPerDay => PlanStatus.done,
        _ when studyDays.contains(today) || studyDays.contains(yesterday) => PlanStatus.onTrack,
        _ => PlanStatus.behind,
      },
    );
  }
}
