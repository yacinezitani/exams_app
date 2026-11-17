import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Logo (two stacked cards on an indigo tile) + wordmark.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    final onPrimary = AppColors.onPrimary(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary(context),
              borderRadius: AppRadius.mark,
            ),
            child: Stack(
              children: [
                PositionedDirectional(
                  start: 9,
                  top: 7,
                  child: Opacity(
                    opacity: 0.55,
                    child: Container(
                      width: 15,
                      height: 19,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: onPrimary, width: 2),
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 13,
                  top: 10,
                  child: Container(
                    width: 15,
                    height: 19,
                    decoration: BoxDecoration(
                      color: onPrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          S.of(context).appName,
          style: AppTextStyles.brand20
              .copyWith(color: AppColors.textPrimary(context)),
        ),
      ],
    );
  }
}
