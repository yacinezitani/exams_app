import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/widgets/app_button.dart';
import 'package:exam_app/core/widgets/app_text_field.dart';
import 'package:exam_app/core/widgets/month_calendar.dart';
import 'package:exam_app/features/onboarding/presentation/view_models/onboarding_cubit.dart';
import 'package:exam_app/features/onboarding/presentation/views/daily_goal_view.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/countdown_chip.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/onboarding_top_bar.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExamSetupViewBody extends StatelessWidget {
  const ExamSetupViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final cubit = context.read<OnboardingCubit>();
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final draft = state.draft;
                final date = draft.examDate;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnboardingTopBar(step: 2),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.examSetupTitle,
                      style: AppTextStyles.heading26
                          .copyWith(color: AppColors.textPrimary(context)),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.examSetupSubtitle,
                      style: AppTextStyles.body16
                          .copyWith(color: AppColors.textMuted(context)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: l10n.userNameLabel,
                      hint: l10n.userNameHint,
                      initialValue: draft.userName,
                      onChanged: cubit.setUserName,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      label: l10n.examNameLabel,
                      hint: l10n.examNameHint,
                      initialValue: draft.examName,
                      onChanged: cubit.setExamName,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.examDateLabel,
                      style: AppTextStyles.label14
                          .copyWith(color: AppColors.textPrimary(context)),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    MonthCalendar(
                      selected: date,
                      firstDate: draft.firstSelectableDate,
                      onSelected: cubit.setExamDate,
                    ),
                    if (date != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      CountdownChip(date: date, daysLeft: draft.daysLeft),
                    ],
                    const Spacer(),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: l10n.continueLabel,
                      onPressed: draft.isExamStepValid
                          ? () => context.push(DailyGoalView.routeName)
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
