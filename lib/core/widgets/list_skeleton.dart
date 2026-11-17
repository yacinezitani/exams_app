import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_shadows.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/utils/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shimmering placeholder tiles (frame 22b). The looping shimmer is allowed
/// here because it is a loading skeleton.
class ListSkeleton extends StatelessWidget {
  final int itemCount;

  const ListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: ExcludeSemantics(
        child: Column(
          children: [
            for (var i = 0; i < itemCount; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              Opacity(opacity: 1 - i * 0.15, child: const _SkeletonTile()),
            ],
          ],
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .shimmer(
            duration: AppAnimations.shimmerDuration,
            curve: Curves.easeInOut,
            color: AppColors.surface(context),
          ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    final line = AppColors.border(context);
    final soft = AppColors.track(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: AppRadius.control,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _Bar(width: 44, height: 44, color: soft, radius: AppRadius.markValue),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: _Bar(height: 14, color: line, radius: 7),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    FractionallySizedBox(
                      widthFactor: 0.45,
                      child: _Bar(height: 10, color: soft, radius: 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _Bar(height: 6, color: soft, radius: 3),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double? width;
  final double height;
  final Color color;
  final double radius;

  const _Bar({this.width, required this.height, required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
