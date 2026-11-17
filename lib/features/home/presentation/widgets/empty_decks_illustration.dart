import 'dart:math' as math;

import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/widgets/dashed_border.dart';
import 'package:flutter/material.dart';

/// Tilted card behind a dashed "add" card (frame 05).
class EmptyDecksIllustration extends StatelessWidget {
  const EmptyDecksIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 150,
        height: 130,
        child: Stack(
          children: [
            PositionedDirectional(
              start: 10,
              top: 14,
              child: Transform.rotate(
                angle: -8 * math.pi / 180,
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft(context),
                    borderRadius: AppRadius.card,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: 36,
              top: 6,
              child: DashedBorder(
                color: AppColors.primaryText(context).withValues(alpha: 0.6),
                radius: AppRadius.cardValue,
                child: Container(
                  width: 104,
                  height: 114,
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: AppRadius.card,
                  ),
                  child: Icon(Icons.add_rounded, size: 36, color: AppColors.primary(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
