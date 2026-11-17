import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/widgets/dashed_border.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Seven dots for the current week: filled = studied, dashed = today pending.
class WeekStreakDots extends StatelessWidget {
  final Set<DateTime> studyDays;
  final DateTime today;

  const WeekStreakDots({super.key, required this.studyDays, required this.today});

  static const double _size = 14;

  @override
  Widget build(BuildContext context) {
    final firstWeekday = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final offset = (today.weekday % 7 - firstWeekday + 7) % 7;
    final days = [
      for (var i = 0; i < 7; i++)
        DateTime(today.year, today.month, today.day - offset + i),
    ];
    final done = days.where(studyDays.contains).length;

    return Semantics(
      label: S.of(context).weekStreakSemantics(done),
      excludeSemantics: true,
      child: Row(
        children: [
          for (final day in days) ...[
            if (day != days.first) const SizedBox(width: AppSpacing.xxs),
            _Dot(
              studied: studyDays.contains(day),
              pendingToday: day == today && !studyDays.contains(day),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool studied;
  final bool pendingToday;

  const _Dot({required this.studied, required this.pendingToday});

  @override
  Widget build(BuildContext context) {
    if (pendingToday) {
      return DashedBorder(
        circle: true,
        color: AppColors.primary(context),
        dash: 3,
        gap: 2.5,
        child: const SizedBox.square(dimension: WeekStreakDots._size),
      );
    }
    return Container(
      width: WeekStreakDots._size,
      height: WeekStreakDots._size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: studied ? AppColors.primary(context) : AppColors.track(context),
      ),
    );
  }
}
