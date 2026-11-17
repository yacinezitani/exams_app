import 'package:flutter/material.dart';

/// Draws a dashed outline (circle or rounded rectangle) over [child].
class DashedBorder extends StatelessWidget {
  final Widget? child;
  final Color color;
  final double strokeWidth;
  final double radius;
  final bool circle;
  final double dash;
  final double gap;

  const DashedBorder({
    super.key,
    required this.color,
    this.child,
    this.strokeWidth = 2,
    this.radius = 0,
    this.circle = false,
    this.dash = 4,
    this.gap = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        radius: radius,
        circle: circle,
        dash: dash,
        gap: gap,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final bool circle;
  final double dash;
  final double gap;

  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.circle,
    required this.dash,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final r = circle ? rect.shortestSide / 2 : radius;
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += dash + gap) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.radius != radius ||
      old.circle != circle ||
      old.dash != dash ||
      old.gap != gap;
}
