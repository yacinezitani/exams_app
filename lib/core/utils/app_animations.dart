import 'package:flutter/animation.dart';

abstract final class AppAnimations {
  static const Duration entryDuration = Duration(milliseconds: 400);
  static const Duration feedbackDuration = Duration(milliseconds: 250);
  static const Duration shimmerDuration = Duration(milliseconds: 1200);

  static Duration staggerDelay(int index) =>
      Duration(milliseconds: (index * 60).clamp(0, 300));

  static const Curve entryCurve = Curves.easeOut;
  static const Curve feedbackCurve = Curves.easeInOut;
}
