import 'package:exam_app/core/utils/app_animations.dart';
import 'package:flutter/material.dart';

/// Rounded horizontal progress bar; [value] is 0–1 and animates on change.
class AppProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color trackColor;
  final double height;

  const AppProgressBar({
    super.key,
    required this.value,
    required this.color,
    required this.trackColor,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height / 2);
    return Container(
      height: height,
      decoration: BoxDecoration(color: trackColor, borderRadius: radius),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: value.clamp(0, 1)),
        duration: AppAnimations.feedbackDuration,
        curve: AppAnimations.feedbackCurve,
        builder: (_, v, _) => FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: v,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, borderRadius: radius),
          ),
        ),
      ),
    );
  }
}
