import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/utils/app_animations.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Pager dots for the 3 onboarding steps. [step] is 1-based.
class StepIndicator extends StatelessWidget {
  final int step;
  static const int total = 3;

  const StepIndicator({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: S.of(context).stepOfTotal(step, total),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= total; i++) ...[
            if (i > 1) const SizedBox(width: AppSpacing.xxs),
            AnimatedContainer(
              duration: AppAnimations.feedbackDuration,
              curve: AppAnimations.feedbackCurve,
              width: i == step ? AppSpacing.md : AppSpacing.xs,
              height: AppSpacing.xs,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.xxs),
                color: i <= step
                    ? AppColors.primary(context)
                    : AppColors.dotInactive(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
