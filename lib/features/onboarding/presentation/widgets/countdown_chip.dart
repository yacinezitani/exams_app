import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/utils/date_labels.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// "Sat 12 Dec · 25 days to go"
class CountdownChip extends StatelessWidget {
  final DateTime date;
  final int daysLeft;

  const CountdownChip({super.key, required this.date, required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.primarySoftText(context);
    final locale = Localizations.localeOf(context).toString();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs + AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft(context),
        borderRadius: AppRadius.control,
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month_rounded, size: 20, color: color),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              S.of(context).examCountdown(DateLabels.shortDate(locale, date), daysLeft),
              style: AppTextStyles.label14.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
