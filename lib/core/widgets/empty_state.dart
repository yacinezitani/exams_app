import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Centered illustration + title + body (frame 22a pattern).
class EmptyState extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String body;

  const EmptyState({
    super.key,
    required this.illustration,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          illustration,
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.empty20
                .copyWith(color: AppColors.textPrimary(context)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTextStyles.body15
                .copyWith(color: AppColors.textMuted(context)),
          ),
        ],
      ),
    );
  }
}
