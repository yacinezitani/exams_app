import 'package:exam_app/core/models/deck_summary_model.dart';
import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_shadows.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/widgets/app_progress_bar.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Compact deck card: colour tag, title, "48 cards · 12 due", mastery bar.
class DeckTile extends StatelessWidget {
  final DeckSummaryModel summary;
  final VoidCallback onTap;

  const DeckTile({super.key, required this.summary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final accent = Color(summary.deck.color);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final cards = l10n.deckCardCount(summary.cardCount);
    final due = l10n.deckDueCount(summary.dueCount);

    return Semantics(
      button: true,
      label: l10n.deckTileSemantics(summary.deck.name, cards, due),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: AppRadius.control,
          boxShadow: AppShadows.soft,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.control,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ColorTag(color: accent, alpha: dark ? 0.24 : 0.12),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    summary.deck.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.tile15
                        .copyWith(color: AppColors.textPrimary(context)),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.body12
                          .copyWith(color: AppColors.textMuted(context)),
                      children: [
                        TextSpan(text: '$cards · '),
                        TextSpan(
                          text: due,
                          style: AppTextStyles.caption12
                              .copyWith(color: AppColors.primaryText(context)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppProgressBar(
                    value: summary.mastery,
                    color: accent,
                    trackColor: AppColors.track(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorTag extends StatelessWidget {
  final Color color;
  final double alpha;

  const _ColorTag({required this.color, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: alpha),
        borderRadius: AppRadius.mark,
      ),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
