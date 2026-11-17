import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Full-width primary action. [onPressed] null = disabled.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  static const double _height = 56;

  @override
  Widget build(BuildContext context) {
    final onPrimary = AppColors.onPrimary(context);
    return FilledButton(
      // Loading keeps the active look; the no-op blocks double taps.
      onPressed: isLoading ? () {} : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(_height),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.control),
        backgroundColor: AppColors.primary(context),
        foregroundColor: onPrimary,
        disabledBackgroundColor: AppColors.border(context),
        disabledForegroundColor: AppColors.textMuted(context),
        textStyle: AppTextStyles.button16,
      ),
      child: isLoading
          ? SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: onPrimary),
            )
          : icon == null
              ? Text(label)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(child: Text(label)),
                  ],
                ),
    );
  }
}
