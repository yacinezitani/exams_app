import 'package:exam_app/core/data/repos/settings_repo.dart';
import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/utils/date_extensions.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:exam_app/features/onboarding/presentation/view_models/onboarding_draft.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SettingsRepo _repo;

  /// [now] is injectable so tests can pin the date.
  OnboardingCubit(this._repo, {DateTime Function()? now})
      : super(OnboardingSuccess(
          OnboardingDraft(today: (now ?? DateTime.now)().dateOnly),
        ));

  bool get _isSaving => state is OnboardingLoading;

  void setUserName(String value) {
    if (_isSaving) return;
    emit(OnboardingSuccess(state.draft.copyWith(userName: value)));
  }

  void setExamName(String value) {
    if (_isSaving) return;
    emit(OnboardingSuccess(state.draft.copyWith(examName: value)));
  }

  void setExamDate(DateTime value) {
    if (_isSaving) return;
    emit(OnboardingSuccess(state.draft.copyWith(examDate: value.dateOnly)));
  }

  void setDailyGoal(DailyGoal value) {
    if (_isSaving) return;
    emit(OnboardingSuccess(state.draft.copyWith(dailyGoal: value)));
  }

  Future<void> submit() async {
    final draft = state.draft;
    if (_isSaving || !draft.isExamStepValid) return;
    emit(OnboardingLoading(draft));

    final result = await _repo.completeOnboarding(
      examName: draft.examName.trim(),
      examDate: draft.examDate!, // non-null: isExamStepValid checked above
      dailyGoal: draft.dailyGoal,
      userName: draft.userName.trim(),
    );
    if (isClosed) return;

    result.fold(
      (_) => emit(OnboardingComplete(draft)),
      (failure) => emit(OnboardingFailure(draft, failure.error)),
    );
  }
}
