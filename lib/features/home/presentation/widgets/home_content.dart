import 'package:exam_app/core/theme/app_colors.dart';
import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/theme/app_text_styles.dart';
import 'package:exam_app/core/utils/app_animations.dart';
import 'package:exam_app/core/utils/date_extensions.dart';
import 'package:exam_app/core/widgets/app_button.dart';
import 'package:exam_app/features/decks/presentation/views/deck_detail_view.dart';
import 'package:exam_app/features/decks/presentation/views/decks_view.dart';
import 'package:exam_app/features/home/presentation/view_models/home_cubit.dart';
import 'package:exam_app/features/home/presentation/view_models/home_data.dart';
import 'package:exam_app/features/home/presentation/widgets/countdown_card.dart';
import 'package:exam_app/features/home/presentation/widgets/home_decks_section.dart';
import 'package:exam_app/features/home/presentation/widgets/home_greeting.dart';
import 'package:exam_app/features/home/presentation/widgets/stat_card.dart';
import 'package:exam_app/features/home/presentation/widgets/week_streak_dots.dart';
import 'package:exam_app/features/plan/presentation/views/plan_view.dart';
import 'package:exam_app/features/settings/presentation/views/settings_view.dart';
import 'package:exam_app/features/study/presentation/views/study_view.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:exam_app/core/domain/daily_plan_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Frame 04: Home with decks.
class HomeContent extends StatelessWidget {
  final HomeData data;

  const HomeContent({super.key, required this.data});

  /// Pushes a route, then refreshes Home when the user comes back.
  Future<void> _push(BuildContext context, String location) async {
    final cubit = context.read<HomeCubit>();
    await context.push(location);
    cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final due = data.due;
    final today = data.now.dateOnly;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeGreeting(now: data.now, userName: data.userName),
                    const SizedBox(height: AppSpacing.sm),
                    CountdownCard(
                      data: data,
                      onOpenPlan: () => _push(context, PlanView.routeName),
                      onSetDate: () => context.go(SettingsView.routeName),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: StatCard(
                              icon: Icons.crop_portrait_rounded,
                              iconColor: AppColors.primary(context),
                              label: l10n.dueTodayLabel,
                              value: '${due.total}',
                              unit: l10n.cardsUnit(due.total),
                              footer: _DueFooter(data: data),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: StatCard(
                              icon: Icons.local_fire_department_rounded,
                              iconColor: AppColors.streak(context),
                              label: l10n.streakLabel,
                              value: '${data.streak}',
                              unit: l10n.daysUnit(data.streak),
                              footer: Padding(
                                padding: const EdgeInsets.only(top: AppSpacing.xxs),
                                child: WeekStreakDots(studyDays: data.studyDays, today: today),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    HomeDecksSection(
                      decks: data.decks,
                      onSeeAll: () => context.go(DecksView.routeName),
                      // id is never null for rows read from the database.
                      onOpenDeck: (deck) =>
                          _push(context, DeckDetailView.location(deck.deck.id!)),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(
                      duration: AppAnimations.entryDuration,
                      curve: AppAnimations.entryCurve,
                    )
                    .slideY(
                      begin: 0.04,
                      end: 0,
                      duration: AppAnimations.entryDuration,
                      curve: AppAnimations.entryCurve,
                    ),
                const Spacer(),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: due.total > 0 ? l10n.startStudying(due.total) : l10n.nothingDueButton,
                  onPressed: due.total > 0
                      ? () => _push(context, StudyView.location(StudyView.allDecks))
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DueFooter extends StatelessWidget {
  final HomeData data;

  const _DueFooter({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final due = data.due;
    final text = due.total == 0
        ? l10n.allCaughtUp
        : l10n.dueBreakdown(due.reviewCount, due.newCount, estimateMinutes(due.total));
    return Text(
      text,
      style: AppTextStyles.body12.copyWith(color: AppColors.textMuted(context)),
    );
  }
}
