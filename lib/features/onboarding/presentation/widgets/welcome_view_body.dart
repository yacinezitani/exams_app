import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/utils/app_animations.dart';
import 'package:exam_app/core/widgets/app_button.dart';
import 'package:exam_app/features/onboarding/presentation/views/exam_setup_view.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/brand_mark.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/flashcard_stack_illustration.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/step_indicator.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class WelcomeViewBody extends StatelessWidget {
  const WelcomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandMark(),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(child: FlashcardStackIllustration()),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcomeTitle,
                      style: AppTextStyles.display32
                          .copyWith(color: AppColors.textPrimary(context)),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.welcomeBody,
                      style: AppTextStyles.body16
                          .copyWith(color: AppColors.textMuted(context)),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(
                      duration: AppAnimations.entryDuration,
                      curve: AppAnimations.entryCurve,
                    )
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: AppAnimations.entryDuration,
                      curve: AppAnimations.entryCurve,
                    ),
                const SizedBox(height: AppSpacing.md),
                const StepIndicator(step: 1),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: l10n.getStarted,
                  onPressed: () => context.push(ExamSetupView.routeName),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
