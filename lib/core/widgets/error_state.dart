import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/widgets/app_button.dart';
import 'package:exam_app/core/widgets/empty_state.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Full-area error with a retry action (frame 22c pattern).
class ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyState(
            illustration: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.missSoft(context).withValues(alpha: 0.5),
                borderRadius: AppRadius.card,
              ),
              child: Icon(Icons.cloud_off_rounded, size: 40, color: AppColors.miss(context)),
            ),
            title: l10n.errorGeneric,
            body: '',
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(label: l10n.retry, onPressed: onRetry),
        ],
      ),
    );
  }
}
