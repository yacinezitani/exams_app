import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/view_models/settings_cubit/settings_cubit.dart';
import 'package:exam_app/core/widgets/app_button.dart';
import 'package:exam_app/features/onboarding/presentation/view_models/onboarding_cubit.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/goal_option_tile.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/goal_summary_card.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/onboarding_top_bar.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyGoalViewBody extends StatelessWidget {
  const DailyGoalViewBody({super.key});

  void _onStateChanged(BuildContext context, OnboardingState state) {
    switch (state) {
      case OnboardingFailure():
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(S.of(context).saveError)));
      case OnboardingComplete():
        // The router redirects to Home once settings report "onboarded".
        context.read<SettingsCubit>().load();
      case OnboardingSuccess() || OnboardingLoading():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final cubit = context.read<OnboardingCubit>();
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final draft = state.draft;
        final date = draft.examDate;
        return CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnboardingTopBar(step: 3),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.goalTitle,
                      style: AppTextStyles.heading26
                          .copyWith(color: AppColors.textPrimary(context)),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.goalSubtitle,
                      style: AppTextStyles.body16
                          .copyWith(color: AppColors.textMuted(context)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    for (final goal in DailyGoal.values) ...[
                      GoalOptionTile(
                        goal: goal,
                        selected: goal == draft.dailyGoal,
                        onTap: () => cubit.setDailyGoal(goal),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    if (date != null)
                      GoalSummaryCard(
                        reviews: draft.estimatedReviews,
                        examName: draft.examName.trim(),
                        examDate: date,
                      ),
                    const Spacer(),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: l10n.startLearning,
                      isLoading: state is OnboardingLoading,
                      onPressed:
                          draft.isExamStepValid ? cubit.submit : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
