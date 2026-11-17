import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_radius.dart';
import 'package:exam_app/core/theme/app_shadows.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/utils/date_labels.dart';
import 'package:exam_app/core/widgets/app_progress_bar.dart';
import 'package:exam_app/features/home/presentation/view_models/home_data.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Indigo exam countdown. Handles four phases: counting down, exam day,
/// exam passed / no date, and the "no decks yet" hint.
class CountdownCard extends StatelessWidget {
  final HomeData data;
  final VoidCallback onOpenPlan;
  final VoidCallback onSetDate;

  const CountdownCard({
    super.key,
    required this.data,
    required this.onOpenPlan,
    required this.onSetDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final locale = Localizations.localeOf(context).toString();
    final date = data.examDate;
    final label = date == null
        ? data.examName
        : l10n.countdownLabel(data.examName, DateLabels.shortDate(locale, date));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary(context),
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.primaryGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.overline(context)
                      .copyWith(color: AppColors.onPrimaryMuted(context)),
                ),
              ),
              if (!data.isEmpty && data.daysLeft >= 0)
                Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.onPrimary(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _Headline(daysLeft: data.daysLeft),
          if (data.daysLeft < 0)
            _SetDateLink(onTap: onSetDate)
          else if (data.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.emptyCountdownHint,
                style: AppTextStyles.body13.copyWith(color: AppColors.onPrimaryMuted(context)),
              ),
            )
          else
            _PlanProgress(data: data, onOpenPlan: onOpenPlan),
        ],
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  final int daysLeft;

  const _Headline({required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final onPrimary = AppColors.onPrimary(context);
    if (daysLeft < 0) {
      return Text(
        l10n.examPassedTitle,
        style: AppTextStyles.empty20.copyWith(color: onPrimary),
      );
    }
    if (daysLeft == 0) {
      return Text(
        l10n.examDayToday,
        style: AppTextStyles.empty20.copyWith(color: onPrimary),
      );
    }
    return Semantics(
      label: '$daysLeft ${l10n.daysToGoUnit(daysLeft)}',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text('$daysLeft', style: AppTextStyles.countdown44.copyWith(color: onPrimary)),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              l10n.daysToGoUnit(daysLeft),
              style: AppTextStyles.countdownUnit18.copyWith(color: onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetDateLink extends StatelessWidget {
  final VoidCallback onTap;

  const _SetDateLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.control,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            S.of(context).setNewDate,
            style: AppTextStyles.label14.copyWith(
              color: AppColors.onPrimary(context),
              decoration: TextDecoration.underline,
              decorationColor: AppColors.onPrimary(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanProgress extends StatelessWidget {
  final HomeData data;
  final VoidCallback onOpenPlan;

  const _PlanProgress({required this.data, required this.onOpenPlan});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final onPrimary = AppColors.onPrimary(context);
    final status = switch (data.planStatus) {
      PlanStatus.done => l10n.planStatusDone,
      PlanStatus.onTrack => l10n.planStatusOnTrack,
      PlanStatus.behind => l10n.planStatusBehind,
    };
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        AppProgressBar(
          value: data.planProgress,
          color: onPrimary,
          trackColor: onPrimary.withValues(alpha: 0.25),
          height: 8,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.planSummary((data.planProgress * 100).round(), status),
                style: AppTextStyles.body13.copyWith(color: AppColors.onPrimaryMuted(context)),
              ),
            ),
            InkWell(
              onTap: onOpenPlan,
              borderRadius: AppRadius.control,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.dailyPlanLink,
                      style: AppTextStyles.label13.copyWith(color: onPrimary),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 18, color: onPrimary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
