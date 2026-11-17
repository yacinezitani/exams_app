import 'package:exam_app/core/models/deck_summary_model.dart';
import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/widgets/deck_tile.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// "Your decks" header + the two decks with the most cards due.
class HomeDecksSection extends StatelessWidget {
  final List<DeckSummaryModel> decks;
  final VoidCallback onSeeAll;
  final ValueChanged<DeckSummaryModel> onOpenDeck;

  const HomeDecksSection({
    super.key,
    required this.decks,
    required this.onSeeAll,
    required this.onOpenDeck,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final shown = decks.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.yourDecks,
              style: AppTextStyles.section18.copyWith(color: AppColors.textPrimary(context)),
            ),
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              child: Text(
                l10n.seeAll,
                style: AppTextStyles.label14.copyWith(color: AppColors.primaryText(context)),
              ),
            ),
          ],
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < 2; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: i < shown.length
                      ? DeckTile(summary: shown[i], onTap: () => onOpenDeck(shown[i]))
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
