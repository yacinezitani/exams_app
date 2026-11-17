import 'package:exam_app/core/theme/app_spacing.dart';
import 'package:exam_app/core/utils/app_animations.dart';
import 'package:exam_app/core/widgets/app_button.dart';
import 'package:exam_app/core/widgets/empty_state.dart';
import 'package:exam_app/features/decks/presentation/views/deck_edit_view.dart';
import 'package:exam_app/features/home/presentation/view_models/home_cubit.dart';
import 'package:exam_app/features/home/presentation/view_models/home_data.dart';
import 'package:exam_app/features/home/presentation/widgets/countdown_card.dart';
import 'package:exam_app/features/home/presentation/widgets/empty_decks_illustration.dart';
import 'package:exam_app/features/home/presentation/widgets/home_greeting.dart';
import 'package:exam_app/features/settings/presentation/views/settings_view.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Frame 05: Home before any deck exists.
class HomeEmptyContent extends StatelessWidget {
  final HomeData data;

  const HomeEmptyContent({super.key, required this.data});

  Future<void> _createDeck(BuildContext context) async {
    final cubit = context.read<HomeCubit>();
    await context.push(DeckEditView.routeName);
    cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
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
                HomeGreeting(now: data.now, userName: data.userName, welcome: true),
                const SizedBox(height: AppSpacing.sm),
                CountdownCard(
                  data: data,
                  onOpenPlan: () {},
                  onSetDate: () => context.go(SettingsView.routeName),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: EmptyState(
                        illustration: const EmptyDecksIllustration(),
                        title: l10n.emptyDecksTitle,
                        body: l10n.emptyDecksBody,
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
                    ),
                  ),
                ),
                AppButton(
                  label: l10n.createFirstDeck,
                  icon: Icons.add_rounded,
                  onPressed: () => _createDeck(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
