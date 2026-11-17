import 'dart:math' as math;

import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_shadows.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Decorative stack of three flashcards for the welcome screen.
class FlashcardStackIllustration extends StatelessWidget {
  const FlashcardStackIllustration({super.key});

  static const double _width = 240;
  static const double _height = 300;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _BackCard(
            color: AppColors.successSoft(context),
            angle: 10,
            offset: const Offset(28, 6),
          ),
          _BackCard(
            color: AppColors.primarySoft(context),
            angle: -8,
            offset: const Offset(-26, 4),
          ),
          const _FrontCard(),
        ],
      ),
    );
  }
}

class _BackCard extends StatelessWidget {
  final Color color;
  final double angle;
  final Offset offset;

  const _BackCard({required this.color, required this.angle, required this.offset});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle * math.pi / 180,
        child: Container(
          width: FlashcardStackIllustration._width,
          height: FlashcardStackIllustration._height,
          decoration: BoxDecoration(color: color, borderRadius: AppRadius.card),
        ),
      ),
    );
  }
}

class _FrontCard extends StatelessWidget {
  const _FrontCard();

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Container(
      width: FlashcardStackIllustration._width,
      constraints:
          const BoxConstraints(minHeight: FlashcardStackIllustration._height),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.elevated,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.sampleQuestionLabel,
                style: AppTextStyles.overline(context)
                    .copyWith(color: AppColors.primaryText(context)),
              ),
              Text(
                l10n.sampleSubject,
                style: AppTextStyles.caption12
                    .copyWith(color: AppColors.textMuted(context)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.sampleQuestion,
            textAlign: TextAlign.center,
            style: AppTextStyles.card22
                .copyWith(color: AppColors.textPrimary(context)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RatingDot(
                icon: Icons.close_rounded,
                color: AppColors.miss(context),
                border: AppColors.missSoft(context),
              ),
              const SizedBox(width: AppSpacing.xs),
              _RatingDot(
                icon: Icons.check_rounded,
                color: AppColors.success(context),
                border: AppColors.successBorder(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingDot extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color border;

  const _RatingDot({required this.icon, required this.color, required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}
