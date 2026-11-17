import 'package:exam_app/core/models/daily_goal.dart';
import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/utils/app_animations.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

extension DailyGoalL10n on DailyGoal {
  String title(S l10n) => switch (this) {
        DailyGoal.light => l10n.goalLight,
        DailyGoal.steady => l10n.goalSteady,
        DailyGoal.focused => l10n.goalFocused,
        DailyGoal.intense => l10n.goalIntense,
      };
}

/// One radio row in the daily goal list.
class GoalOptionTile extends StatelessWidget {
  final DailyGoal goal;
  final bool selected;
  final VoidCallback onTap;

  const GoalOptionTile({
    super.key,
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final primary = AppColors.primary(context);
    return MergeSemantics(
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        checked: selected,
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.control,
            child: AnimatedContainer(
              duration: AppAnimations.feedbackDuration,
              curve: AppAnimations.feedbackCurve,
              constraints: const BoxConstraints(minHeight: 76),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: AppRadius.control,
                border: Border.all(
                  color: selected ? primary : AppColors.border(context),
                  width: selected ? 2 : 1.5,
                ),
              ),
              child: Row(
                children: [
                  _Badge(cards: goal.cards, selected: selected),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title(l10n),
                          style: AppTextStyles.title16
                              .copyWith(color: AppColors.textPrimary(context)),
                        ),
                        Text(
                          l10n.goalMinutes(goal.minutes),
                          style: AppTextStyles.body14
                              .copyWith(color: AppColors.textMuted(context)),
                        ),
                      ],
                    ),
                  ),
                  if (goal == DailyGoal.recommended) ...[
                    const SizedBox(width: AppSpacing.xs),
                    const _RecommendedPill(),
                  ],
                  const SizedBox(width: AppSpacing.xs),
                  _RadioDot(selected: selected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int cards;
  final bool selected;

  const _Badge({required this.cards, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppAnimations.feedbackDuration,
      curve: AppAnimations.feedbackCurve,
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: AppRadius.mark,
        color: selected
            ? AppColors.primary(context)
            : AppColors.primarySoft(context),
      ),
      child: Text(
        '$cards',
        style: AppTextStyles.goalNumber18.copyWith(
          color: selected
              ? AppColors.onPrimary(context)
              : AppColors.primaryText(context),
        ),
      ),
    );
  }
}

class _RecommendedPill extends StatelessWidget {
  const _RecommendedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.successSoft(context),
        borderRadius: AppRadius.mark,
      ),
      child: Text(
        S.of(context).recommended,
        style: AppTextStyles.caption12
            .copyWith(color: AppColors.successText(context)),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;

  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.primary(context) : AppColors.dotInactive(context);
    return AnimatedContainer(
      duration: AppAnimations.feedbackDuration,
      curve: AppAnimations.feedbackCurve,
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: AnimatedContainer(
        duration: AppAnimations.feedbackDuration,
        curve: AppAnimations.feedbackCurve,
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : Colors.transparent,
        ),
      ),
    );
  }
}
