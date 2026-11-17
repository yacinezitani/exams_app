import 'dart:async';

import 'package:exam_app/core/view_models/settings_cubit/settings_cubit.dart';
import 'package:exam_app/core/routing/main_shell_view.dart';
import 'package:exam_app/features/decks/presentation/views/deck_detail_view.dart';
import 'package:exam_app/features/decks/presentation/views/deck_edit_view.dart';
import 'package:exam_app/features/decks/presentation/views/decks_view.dart';
import 'package:exam_app/features/home/presentation/views/home_view.dart';
import 'package:exam_app/features/plan/presentation/views/plan_view.dart';
import 'package:exam_app/features/settings/presentation/views/settings_view.dart';
import 'package:exam_app/features/stats/presentation/views/stats_view.dart';
import 'package:exam_app/features/study/presentation/views/study_view.dart';
import 'package:exam_app/features/onboarding/presentation/views/daily_goal_view.dart';
import 'package:exam_app/features/onboarding/presentation/views/exam_setup_view.dart';
import 'package:exam_app/features/onboarding/presentation/views/onboarding_shell.dart';
import 'package:exam_app/features/onboarding/presentation/views/welcome_view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Owns the [GoRouter]. Call [dispose] when the app widget is disposed.
class AppRouter {
  final SettingsCubit _settings;
  late final _Refresh _refresh = _Refresh(_settings.stream);

  AppRouter(this._settings);

  late final GoRouter router = GoRouter(
    initialLocation: HomeView.routeName,
    refreshListenable: _refresh,
    redirect: _redirect,
    routes: [
      ShellRoute(
        builder: (context, state, child) => OnboardingShell(child: child),
        routes: [
          GoRoute(
            path: WelcomeView.routeName,
            builder: (_, _) => const WelcomeView(),
          ),
          GoRoute(
            path: ExamSetupView.routeName,
            builder: (_, _) => const ExamSetupView(),
          ),
          GoRoute(
            path: DailyGoalView.routeName,
            builder: (_, _) => const DailyGoalView(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShellView(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: HomeView.routeName, builder: (_, _) => const HomeView()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: DecksView.routeName, builder: (_, _) => const DecksView()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: StatsView.routeName, builder: (_, _) => const StatsView()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: SettingsView.routeName, builder: (_, _) => const SettingsView()),
          ]),
        ],
      ),
      // Full-screen routes (no bottom nav). Literal /decks/edit is declared
      // before /decks/:id so it is not read as an id.
      GoRoute(path: DeckEditView.routeName, builder: (_, _) => const DeckEditView()),
      GoRoute(
        path: DeckDetailView.routeName,
        builder: (_, state) => DeckDetailView(id: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: StudyView.routeName,
        builder: (_, state) => StudyView(deckId: state.pathParameters['deckId']!),
      ),
      GoRoute(path: PlanView.routeName, builder: (_, _) => const PlanView()),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final onboarded = switch (_settings.state) {
      SettingsSuccess(:final settings) => settings.isOnboarded,
      SettingsFailure() => false,
      SettingsInitial() || SettingsLoading() => null,
    };
    if (onboarded == null) return null;

    final inOnboarding = state.matchedLocation.startsWith(WelcomeView.routeName);
    if (!onboarded && !inOnboarding) return WelcomeView.routeName;
    if (onboarded && inOnboarding) return HomeView.routeName;
    return null;
  }

  void dispose() {
    router.dispose();
    _refresh.dispose();
  }
}

class _Refresh extends ChangeNotifier {
  late final StreamSubscription<Object?> _sub;

  _Refresh(Stream<Object?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
