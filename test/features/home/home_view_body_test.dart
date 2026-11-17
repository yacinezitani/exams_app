import 'package:bloc_test/bloc_test.dart';
import 'package:exam_app/core/domain/daily_plan_use_case.dart';
import 'package:exam_app/core/models/deck_model.dart';
import 'package:exam_app/core/models/deck_summary_model.dart';
import 'package:exam_app/core/models/due_summary_model.dart';
import 'package:exam_app/core/view_models/settings_cubit/settings_cubit.dart';
import 'package:exam_app/core/widgets/list_skeleton.dart';
import 'package:exam_app/features/home/presentation/view_models/home_cubit.dart';
import 'package:exam_app/features/home/presentation/view_models/home_data.dart';
import 'package:exam_app/features/home/presentation/widgets/home_view_body.dart';
import 'package:exam_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class _MockSettingsCubit extends MockCubit<SettingsState> implements SettingsCubit {}

HomeData _data({
  List<DeckSummaryModel>? decks,
  DueSummaryModel due = const DueSummaryModel(reviewCount: 20, newCount: 12),
  int daysLeft = 25,
}) =>
    HomeData(
      now: DateTime(2026, 11, 17, 9),
      userName: 'Amira',
      examName: 'Biology Final',
      examDate: DateTime(2026, 12, 12),
      daysLeft: daysLeft,
      decks: decks ??
          [
            DeckSummaryModel(
              deck: DeckModel(
                id: 1,
                name: 'Cell Biology',
                subject: 'Biology',
                color: 0xFF4F46E5,
                createdAt: DateTime(2026, 11, 1),
              ),
              cardCount: 48,
              dueCount: 12,
              masteredCount: 34,
            ),
          ],
      due: due,
      streak: 12,
      studyDays: {DateTime(2026, 11, 16)},
      plan: const PlanActive(30),
      studiedToday: 0,
      planProgress: 0.38,
      planStatus: PlanStatus.onTrack,
    );

void main() {
  late _MockHomeCubit home;

  setUp(() {
    home = _MockHomeCubit();
  });

  Future<void> pump(
    WidgetTester tester,
    HomeState state, {
    Locale locale = const Locale('en'),
    double textScale = 1,
  }) async {
    when(() => home.state).thenReturn(state);
    final settings = _MockSettingsCubit();
    when(() => settings.state).thenReturn(const SettingsInitial());
    await tester.binding.setSurfaceSize(const Size(390, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>.value(value: home),
          BlocProvider<SettingsCubit>.value(value: settings),
        ],
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const Scaffold(body: HomeViewBody()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
  }

  FilledButton primaryButton(WidgetTester tester) =>
      tester.widget(find.byType(FilledButton));

  testWidgets('with decks: countdown, due, streak, deck tile and study CTA', (tester) async {
    await pump(tester, HomeSuccess(_data()));

    expect(find.text('Good morning, Amira'), findsOneWidget);
    expect(find.text('Tuesday, 17 November'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    expect(find.text('days to go'), findsOneWidget);
    expect(find.textContaining('Plan 38% done'), findsOneWidget);
    expect(find.text('Cell Biology'), findsOneWidget);
    expect(find.text('20 reviews · 12 new · ~16 min'), findsOneWidget);
    expect(find.text('Start studying · 32 cards'), findsOneWidget);
    expect(primaryButton(tester).onPressed, isNotNull);
  });

  testWidgets('nothing due disables the study button', (tester) async {
    await pump(tester, HomeSuccess(_data(due: const DueSummaryModel())));

    expect(find.text('All caught up'), findsOneWidget);
    expect(find.text('All caught up for today'), findsOneWidget);
    expect(primaryButton(tester).onPressed, isNull);
  });

  testWidgets('no decks shows the empty state and create CTA', (tester) async {
    await pump(tester, HomeSuccess(_data(decks: [])));

    expect(find.text('Welcome, Amira'), findsOneWidget);
    expect(find.text('No decks yet'), findsOneWidget);
    expect(find.text('Create your first deck'), findsOneWidget);
    expect(find.text('Add a deck and we’ll build your daily plan.'), findsOneWidget);
    expect(primaryButton(tester).onPressed, isNotNull);
  });

  testWidgets('a passed exam offers to set a new date', (tester) async {
    await pump(tester, HomeSuccess(_data(daysLeft: -3)));

    expect(find.text('Your exam date has passed'), findsOneWidget);
    expect(find.text('Set a new date'), findsOneWidget);
    expect(find.textContaining('Plan 38% done'), findsNothing);
  });

  testWidgets('exam day replaces the number with a message', (tester) async {
    await pump(tester, HomeSuccess(_data(daysLeft: 0)));

    expect(find.text('Exam day — good luck'), findsOneWidget);
  });

  testWidgets('loading shows the skeleton', (tester) async {
    when(() => home.state).thenReturn(const HomeLoading());
    final settings = _MockSettingsCubit();
    when(() => settings.state).thenReturn(const SettingsInitial());
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>.value(value: home),
          BlocProvider<SettingsCubit>.value(value: settings),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [Locale('en')],
          home: Scaffold(body: HomeViewBody()),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ListSkeleton), findsOneWidget);

    // Dispose the looping shimmer so no timer outlives the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('failure offers a retry that reloads', (tester) async {
    when(() => home.load()).thenAnswer((_) async {});
    await pump(tester, const HomeFailure('boom'));

    await tester.tap(find.text('Try again'));
    verify(() => home.load()).called(1);
  });

  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final scale in const [1.0, 1.5]) {
      for (final (name, data) in [
        ('with decks', _data()),
        ('empty', _data(decks: [])),
        ('exam passed', _data(daysLeft: -3)),
      ]) {
        testWidgets('no overflow: $name, $locale, text ×$scale', (tester) async {
          await pump(tester, HomeSuccess(data), locale: locale, textScale: scale);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
