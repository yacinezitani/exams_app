import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_shadows.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// White tile: icon + label, big value with unit, footer widget.
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final Widget footer;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textMuted(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: AppRadius.control,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label13.copyWith(color: muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text.rich(
            TextSpan(
              text: value,
              style: AppTextStyles.statValue26.copyWith(color: AppColors.textPrimary(context)),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: AppTextStyles.unit14.copyWith(color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          footer,
        ],
      ),
    );
  }
}
