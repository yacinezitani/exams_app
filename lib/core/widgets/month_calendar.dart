import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_shadows.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/utils/date_extensions.dart';
import 'package:exam_app/core/utils/date_labels.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Month grid date picker. Days before [firstDate] are disabled.
/// Rows are 48 px tall so every day meets the minimum tap target.
class MonthCalendar extends StatefulWidget {
  final DateTime? selected;
  final DateTime firstDate;
  final ValueChanged<DateTime> onSelected;

  const MonthCalendar({
    super.key,
    required this.selected,
    required this.firstDate,
    required this.onSelected,
  });

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  static const double _cell = 48;
  static const double _circle = 36;

  late DateTime _month = _monthOf(widget.selected ?? widget.firstDate);

  static DateTime _monthOf(DateTime d) => DateTime(d.year, d.month);

  bool get _canGoBack => _month.isAfter(_monthOf(widget.firstDate));

  void _shift(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final l10n = MaterialLocalizations.of(context);
    final first = l10n.firstDayOfWeekIndex;
    // Sunday = 0, matching MaterialLocalizations.narrowWeekdays.
    final leading = (_month.weekday % 7 - first + 7) % 7;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final rows = ((leading + daysInMonth) / 7).ceil();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: AppRadius.control,
        boxShadow: AppShadows.soft,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          children: [
            _Header(
              title: DateLabels.monthYear(locale, _month),
              onPrevious: _canGoBack ? () => _shift(-1) : null,
              onNext: () => _shift(1),
            ),
            Row(
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.narrowWeekdays[(first + i) % 7],
                        style: AppTextStyles.caption12
                            .copyWith(color: AppColors.weekday(context)),
                      ),
                    ),
                  ),
              ],
            ),
            for (var r = 0; r < rows; r++)
              Row(
                children: [
                  for (var c = 0; c < 7; c++)
                    Expanded(child: _cellFor(context, locale, r * 7 + c - leading + 1, daysInMonth)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _cellFor(BuildContext context, String locale, int day, int daysInMonth) {
    if (day < 1 || day > daysInMonth) return const SizedBox(height: _cell);

    final date = DateTime(_month.year, _month.month, day);
    final enabled = !date.isBefore(widget.firstDate.dateOnly);
    final selected = widget.selected?.dateOnly == date;

    return Semantics(
      button: true,
      enabled: enabled,
      selected: selected,
      label: DateLabels.fullDate(locale, date),
      excludeSemantics: true,
      onTap: enabled ? () => widget.onSelected(date) : null,
      child: SizedBox(
        height: _cell,
        child: InkResponse(
          onTap: enabled ? () => widget.onSelected(date) : null,
          radius: _cell / 2,
          child: Center(
            child: Container(
              width: _circle,
              height: _circle,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary(context) : null,
              ),
              child: Text(
                '$day',
                style: (selected ? AppTextStyles.day15Selected : AppTextStyles.day15)
                    .copyWith(
                  color: selected
                      ? AppColors.onPrimary(context)
                      : enabled
                          ? AppColors.textPrimary(context)
                          : AppColors.dotInactive(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;

  const _Header({required this.title, required this.onPrevious, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final muted = AppColors.textMuted(context);
    return Row(
      children: [
        IconButton(
          tooltip: l10n.previousMonth,
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
          color: muted,
          disabledColor: AppColors.dotInactive(context),
          style: IconButton.styleFrom(minimumSize: const Size.square(48)),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.month16
                .copyWith(color: AppColors.textPrimary(context)),
          ),
        ),
        IconButton(
          tooltip: l10n.nextMonth,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
          color: muted,
          style: IconButton.styleFrom(minimumSize: const Size.square(48)),
        ),
      ],
    );
  }
}
