part of 'onboarding_cubit.dart';

/// Every state carries the draft so screens can render the user's answers
/// regardless of save progress. [OnboardingSuccess] means "editing".
@immutable
sealed class OnboardingState {
  final OnboardingDraft draft;
  const OnboardingState(this.draft);
}

final class OnboardingSuccess extends OnboardingState {
  const OnboardingSuccess(super.draft);
}

final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading(super.draft);
}

final class OnboardingFailure extends OnboardingState {
  final String errMessage;
  const OnboardingFailure(super.draft, this.errMessage);
}

final class OnboardingComplete extends OnboardingState {
  const OnboardingComplete(super.draft);
}
