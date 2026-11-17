import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/utils/date_labels.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// "About **750 reviews** before your Biology Final on 12 Dec."
class GoalSummaryCard extends StatelessWidget {
  final int reviews;
  final String examName;
  final DateTime examDate;

  const GoalSummaryCard({
    super.key,
    required this.reviews,
    required this.examName,
    required this.examDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final locale = Localizations.localeOf(context).toString();
    final reviewsText = l10n.goalSummaryReviews(reviews);
    final sentence = l10n.goalSummary(
      reviewsText,
      examName,
      DateLabels.dayMonth(locale, examDate),
    );
    final body = AppTextStyles.body14.copyWith(color: AppColors.textMuted(context));
    final strong = AppTextStyles.label14.copyWith(color: AppColors.textPrimary(context));

    // Bold only the review count; word order differs per language, so find it
    // inside the translated sentence instead of assuming a position.
    final at = sentence.indexOf(reviewsText);
    final spans = at < 0
        ? [TextSpan(text: sentence)]
        : [
            TextSpan(text: sentence.substring(0, at)),
            TextSpan(text: reviewsText, style: strong),
            TextSpan(text: sentence.substring(at + reviewsText.length)),
          ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs + AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: AppRadius.control,
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          Icon(Icons.track_changes_rounded, size: 20, color: AppColors.primary(context)),
          const SizedBox(width: AppSpacing.xs),
          Expanded(child: Text.rich(TextSpan(style: body, children: spans))),
        ],
      ),
    );
  }
}
