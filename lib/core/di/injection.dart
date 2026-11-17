import 'package:exam_app/core/data/repos/card_repo.dart';
import 'package:exam_app/core/data/repos/card_repo_impl.dart';
import 'package:exam_app/core/data/repos/deck_repo.dart';
import 'package:exam_app/core/data/repos/deck_repo_impl.dart';
import 'package:exam_app/core/data/repos/review_repo.dart';
import 'package:exam_app/core/data/repos/review_repo_impl.dart';
import 'package:exam_app/core/data/repos/settings_repo.dart';
import 'package:exam_app/core/data/repos/settings_repo_impl.dart';
import 'package:exam_app/core/services/app_database.dart';
import 'package:exam_app/core/services/dev_seed.dart';
import 'package:exam_app/core/view_models/settings_cubit/settings_cubit.dart';
import 'package:exam_app/features/home/presentation/view_models/home_cubit.dart';
import 'package:exam_app/features/onboarding/presentation/view_models/onboarding_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

/// Registers dependencies and loads settings so the router's first redirect
/// already knows whether onboarding is done.
///
/// [databasePath] and [seedDevData] exist for tests.
Future<void> setupInjection({
  String? databasePath,
  bool seedDevData = kDebugMode,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final database = await AppDatabase.open(path: databasePath);
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerSingleton<AppDatabase>(database);
  if (seedDevData) await DevSeed.run(database, prefs);

  // Repos
  sl.registerLazySingleton<SettingsRepo>(() => SettingsRepoImpl(sl()));
  sl.registerLazySingleton<DeckRepo>(() => DeckRepoImpl(sl()));
  sl.registerLazySingleton<CardRepo>(() => CardRepoImpl(sl()));
  sl.registerLazySingleton<ReviewRepo>(() => ReviewRepoImpl(sl()));

  // Global: lives for the app lifetime.
  sl.registerLazySingleton(() => SettingsCubit(sl()));

  // Per view / flow.
  sl.registerFactory(() => OnboardingCubit(sl()));
  sl.registerFactory(() => HomeCubit(
        deckRepo: sl(),
        cardRepo: sl(),
        reviewRepo: sl(),
        settingsRepo: sl(),
      ));

  await sl<SettingsCubit>().load();
}
