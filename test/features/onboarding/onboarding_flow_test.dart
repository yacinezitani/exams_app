import 'package:exam_app/core/di/injection.dart';
import 'package:exam_app/app.dart';
import 'package:exam_app/features/onboarding/presentation/widgets/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('welcome → exam (Continue gated) → goal → home', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    tester.platformDispatcher.localesTestValue = const [Locale('ar')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    // sqflite ffi talks to an isolate: real async, not the fake test clock.
    await tester.runAsync(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      await setupInjection(databasePath: inMemoryDatabasePath, seedDevData: false);
    });
    await tester.pumpWidget(const RecallApp());
    await tester.pumpAndSettle();

    // Welcome (Arabic is the default locale).
    expect(find.byType(StepIndicator), findsOneWidget);
    await tester.tap(find.text('ابدأ الآن'));
    await tester.pumpAndSettle();

    // Exam step: Continue disabled until name + date.
    FilledButton cont() => tester.widget(find.widgetWithText(FilledButton, 'متابعة'));
    expect(cont().onPressed, isNull);

    await tester.enterText(find.byType(TextField).at(0), 'أمل');
    await tester.enterText(find.byType(TextField).at(1), 'امتحان الأحياء');
    await tester.pump();
    expect(cont().onPressed, isNull);

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    // Pick the 28th of next month's calendar when tomorrow isn't visible-safe.
    await tester.tap(find.bySemanticsLabel(RegExp('${tomorrow.day} .* ${tomorrow.year}')).first);
    await tester.pump();
    expect(cont().onPressed, isNotNull);

    await tester.tap(find.widgetWithText(FilledButton, 'متابعة'));
    await tester.pumpAndSettle();

    // Goal step → finish.
    await tester.tap(find.widgetWithText(FilledButton, 'ابدأ التعلّم'));
    // Not pumpAndSettle: Home's loading skeleton shimmers forever.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Home loads from the (empty) database in real async time.
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('أهلًا، أمل'), findsOneWidget);
    expect(find.text('لا توجد مجموعات بعد'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_done'), isTrue);

    // Dispose everything so no animation timer outlives the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
