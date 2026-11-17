import 'package:exam_app/core/di/injection.dart';
import 'package:exam_app/core/routing/app_router.dart';
import 'package:exam_app/core/theme/app_theme.dart';
import 'package:exam_app/core/view_models/settings_cubit/settings_cubit.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class RecallApp extends StatefulWidget {
  const RecallApp({super.key});

  @override
  State<RecallApp> createState() => _RecallAppState();
}

class _RecallAppState extends State<RecallApp> {
  late final AppRouter _appRouter = AppRouter(sl<SettingsCubit>());

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<SettingsCubit>(),
      child: MaterialApp.router(
        onGenerateTitle: (context) => S.of(context).appName,
        routerConfig: _appRouter.router,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
