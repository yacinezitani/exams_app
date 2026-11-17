// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ريكول`
  String get appName {
    return Intl.message('ريكول', name: 'appName', desc: '', args: []);
  }

  /// `ذاكر بذكاء ليوم الامتحان`
  String get welcomeTitle {
    return Intl.message(
      'ذاكر بذكاء ليوم الامتحان',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `أنشئ بطاقات، اقلبها، ودع البطاقات التي أخطأت فيها تعود إليك أسرع. سنخطط لك القليل كل يوم حتى موعد امتحانك.`
  String get welcomeBody {
    return Intl.message(
      'أنشئ بطاقات، اقلبها، ودع البطاقات التي أخطأت فيها تعود إليك أسرع. سنخطط لك القليل كل يوم حتى موعد امتحانك.',
      name: 'welcomeBody',
      desc: '',
      args: [],
    );
  }

  /// `ابدأ الآن`
  String get getStarted {
    return Intl.message('ابدأ الآن', name: 'getStarted', desc: '', args: []);
  }

  /// `سؤال`
  String get sampleQuestionLabel {
    return Intl.message(
      'سؤال',
      name: 'sampleQuestionLabel',
      desc: '',
      args: [],
    );
  }

  /// `التاريخ`
  String get sampleSubject {
    return Intl.message('التاريخ', name: 'sampleSubject', desc: '', args: []);
  }

  /// `في أي عام بدأت الثورة الفرنسية؟`
  String get sampleQuestion {
    return Intl.message(
      'في أي عام بدأت الثورة الفرنسية؟',
      name: 'sampleQuestion',
      desc: '',
      args: [],
    );
  }

  /// `الخطوة {step} من {total}`
  String stepOfTotal(int step, int total) {
    return Intl.message(
      'الخطوة $step من $total',
      name: 'stepOfTotal',
      desc: '',
      args: [step, total],
    );
  }

  /// `رجوع`
  String get back {
    return Intl.message('رجوع', name: 'back', desc: '', args: []);
  }

  /// `لأي امتحان تستعد؟`
  String get examSetupTitle {
    return Intl.message(
      'لأي امتحان تستعد؟',
      name: 'examSetupTitle',
      desc: '',
      args: [],
    );
  }

  /// `سنعدّ الأيام تنازليًا ونوزّع بطاقاتك على الأيام المتبقية.`
  String get examSetupSubtitle {
    return Intl.message(
      'سنعدّ الأيام تنازليًا ونوزّع بطاقاتك على الأيام المتبقية.',
      name: 'examSetupSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `اسم الامتحان`
  String get examNameLabel {
    return Intl.message(
      'اسم الامتحان',
      name: 'examNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `مثال: امتحان الأحياء النهائي`
  String get examNameHint {
    return Intl.message(
      'مثال: امتحان الأحياء النهائي',
      name: 'examNameHint',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ الامتحان`
  String get examDateLabel {
    return Intl.message(
      'تاريخ الامتحان',
      name: 'examDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `الشهر السابق`
  String get previousMonth {
    return Intl.message(
      'الشهر السابق',
      name: 'previousMonth',
      desc: '',
      args: [],
    );
  }

  /// `الشهر التالي`
  String get nextMonth {
    return Intl.message('الشهر التالي', name: 'nextMonth', desc: '', args: []);
  }

  /// `{date} · {days, plural, zero{اليوم} one{باقٍ يوم واحد} two{باقٍ يومان} few{باقٍ {days} أيام} many{باقٍ {days} يومًا} other{باقٍ {days} يوم}}`
  String examCountdown(String date, int days) {
    return Intl.message(
      '$date · ${Intl.plural(days, zero: 'اليوم', one: 'باقٍ يوم واحد', two: 'باقٍ يومان', few: 'باقٍ $days أيام', many: 'باقٍ $days يومًا', other: 'باقٍ $days يوم')}',
      name: 'examCountdown',
      desc: '',
      args: [date, days],
    );
  }

  /// `متابعة`
  String get continueLabel {
    return Intl.message('متابعة', name: 'continueLabel', desc: '', args: []);
  }

  /// `اختر هدفك اليومي`
  String get goalTitle {
    return Intl.message(
      'اختر هدفك اليومي',
      name: 'goalTitle',
      desc: '',
      args: [],
    );
  }

  /// `كم بطاقة في اليوم تراها مناسبة؟ يمكنك تغيير ذلك في أي وقت.`
  String get goalSubtitle {
    return Intl.message(
      'كم بطاقة في اليوم تراها مناسبة؟ يمكنك تغيير ذلك في أي وقت.',
      name: 'goalSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `خفيف`
  String get goalLight {
    return Intl.message('خفيف', name: 'goalLight', desc: '', args: []);
  }

  /// `متوازن`
  String get goalSteady {
    return Intl.message('متوازن', name: 'goalSteady', desc: '', args: []);
  }

  /// `مركّز`
  String get goalFocused {
    return Intl.message('مركّز', name: 'goalFocused', desc: '', args: []);
  }

  /// `مكثّف`
  String get goalIntense {
    return Intl.message('مكثّف', name: 'goalIntense', desc: '', args: []);
  }

  /// `{minutes, plural, few{حوالي {minutes} دقائق يوميًا} many{حوالي {minutes} دقيقة يوميًا} other{حوالي {minutes} دقيقة يوميًا}}`
  String goalMinutes(int minutes) {
    return Intl.plural(
      minutes,
      few: 'حوالي $minutes دقائق يوميًا',
      many: 'حوالي $minutes دقيقة يوميًا',
      other: 'حوالي $minutes دقيقة يوميًا',
      name: 'goalMinutes',
      desc: '',
      args: [minutes],
    );
  }

  /// `موصى به`
  String get recommended {
    return Intl.message('موصى به', name: 'recommended', desc: '', args: []);
  }

  /// `{count, plural, zero{لا مراجعات} one{مراجعة واحدة} two{مراجعتان} few{{count} مراجعات} many{{count} مراجعة} other{{count} مراجعة}}`
  String goalSummaryReviews(int count) {
    return Intl.plural(
      count,
      zero: 'لا مراجعات',
      one: 'مراجعة واحدة',
      two: 'مراجعتان',
      few: '$count مراجعات',
      many: '$count مراجعة',
      other: '$count مراجعة',
      name: 'goalSummaryReviews',
      desc: '',
      args: [count],
    );
  }

  /// `حوالي {reviews} قبل {exam} في {date}.`
  String goalSummary(String reviews, String exam, String date) {
    return Intl.message(
      'حوالي $reviews قبل $exam في $date.',
      name: 'goalSummary',
      desc: '',
      args: [reviews, exam, date],
    );
  }

  /// `ابدأ التعلّم`
  String get startLearning {
    return Intl.message(
      'ابدأ التعلّم',
      name: 'startLearning',
      desc: '',
      args: [],
    );
  }

  /// `تعذّر حفظ إعداداتك. حاول مرة أخرى.`
  String get saveError {
    return Intl.message(
      'تعذّر حفظ إعداداتك. حاول مرة أخرى.',
      name: 'saveError',
      desc: '',
      args: [],
    );
  }

  /// `تستعد لـ {exam}`
  String homePlaceholder(String exam) {
    return Intl.message(
      'تستعد لـ $exam',
      name: 'homePlaceholder',
      desc: '',
      args: [exam],
    );
  }

  /// `صباح الخير`
  String get greetingMorning {
    return Intl.message(
      'صباح الخير',
      name: 'greetingMorning',
      desc: '',
      args: [],
    );
  }

  /// `مساء الخير`
  String get greetingAfternoon {
    return Intl.message(
      'مساء الخير',
      name: 'greetingAfternoon',
      desc: '',
      args: [],
    );
  }

  /// `مساء الخير`
  String get greetingEvening {
    return Intl.message(
      'مساء الخير',
      name: 'greetingEvening',
      desc: '',
      args: [],
    );
  }

  /// `{greeting}، {name}`
  String greetingWithName(String greeting, String name) {
    return Intl.message(
      '$greeting، $name',
      name: 'greetingWithName',
      desc: '',
      args: [greeting, name],
    );
  }

  /// `أهلًا بك`
  String get homeWelcome {
    return Intl.message('أهلًا بك', name: 'homeWelcome', desc: '', args: []);
  }

  /// `أهلًا، {name}`
  String homeWelcomeNamed(String name) {
    return Intl.message(
      'أهلًا، $name',
      name: 'homeWelcomeNamed',
      desc: '',
      args: [name],
    );
  }

  /// `{weekday}، {date}`
  String homeDate(String weekday, String date) {
    return Intl.message(
      '$weekday، $date',
      name: 'homeDate',
      desc: '',
      args: [weekday, date],
    );
  }

  /// `{exam} · {date}`
  String countdownLabel(String exam, String date) {
    return Intl.message(
      '$exam · $date',
      name: 'countdownLabel',
      desc: '',
      args: [exam, date],
    );
  }

  /// `{days, plural, zero{يوم متبقٍ} one{يوم متبقٍ} two{يومان متبقيان} few{أيام متبقية} many{يومًا متبقيًا} other{يوم متبقٍ}}`
  String daysToGoUnit(int days) {
    return Intl.plural(
      days,
      zero: 'يوم متبقٍ',
      one: 'يوم متبقٍ',
      two: 'يومان متبقيان',
      few: 'أيام متبقية',
      many: 'يومًا متبقيًا',
      other: 'يوم متبقٍ',
      name: 'daysToGoUnit',
      desc: '',
      args: [days],
    );
  }

  /// `يوم الامتحان — بالتوفيق`
  String get examDayToday {
    return Intl.message(
      'يوم الامتحان — بالتوفيق',
      name: 'examDayToday',
      desc: '',
      args: [],
    );
  }

  /// `انتهى موعد امتحانك`
  String get examPassedTitle {
    return Intl.message(
      'انتهى موعد امتحانك',
      name: 'examPassedTitle',
      desc: '',
      args: [],
    );
  }

  /// `حدّد تاريخًا جديدًا`
  String get setNewDate {
    return Intl.message(
      'حدّد تاريخًا جديدًا',
      name: 'setNewDate',
      desc: '',
      args: [],
    );
  }

  /// `الخطة {percent}% مكتملة · {status}`
  String planSummary(int percent, String status) {
    return Intl.message(
      'الخطة $percent% مكتملة · $status',
      name: 'planSummary',
      desc: '',
      args: [percent, status],
    );
  }

  /// `أنجزت هدف اليوم`
  String get planStatusDone {
    return Intl.message(
      'أنجزت هدف اليوم',
      name: 'planStatusDone',
      desc: '',
      args: [],
    );
  }

  /// `في المسار الصحيح`
  String get planStatusOnTrack {
    return Intl.message(
      'في المسار الصحيح',
      name: 'planStatusOnTrack',
      desc: '',
      args: [],
    );
  }

  /// `متأخر قليلًا`
  String get planStatusBehind {
    return Intl.message(
      'متأخر قليلًا',
      name: 'planStatusBehind',
      desc: '',
      args: [],
    );
  }

  /// `الخطة اليومية`
  String get dailyPlanLink {
    return Intl.message(
      'الخطة اليومية',
      name: 'dailyPlanLink',
      desc: '',
      args: [],
    );
  }

  /// `أضف مجموعة وسنبني لك خطتك اليومية.`
  String get emptyCountdownHint {
    return Intl.message(
      'أضف مجموعة وسنبني لك خطتك اليومية.',
      name: 'emptyCountdownHint',
      desc: '',
      args: [],
    );
  }

  /// `مستحقة اليوم`
  String get dueTodayLabel {
    return Intl.message(
      'مستحقة اليوم',
      name: 'dueTodayLabel',
      desc: '',
      args: [],
    );
  }

  /// `أيام متتالية`
  String get streakLabel {
    return Intl.message(
      'أيام متتالية',
      name: 'streakLabel',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, zero{بطاقة} one{بطاقة} two{بطاقتان} few{بطاقات} many{بطاقة} other{بطاقة}}`
  String cardsUnit(int count) {
    return Intl.plural(
      count,
      zero: 'بطاقة',
      one: 'بطاقة',
      two: 'بطاقتان',
      few: 'بطاقات',
      many: 'بطاقة',
      other: 'بطاقة',
      name: 'cardsUnit',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, zero{يوم} one{يوم} two{يومان} few{أيام} many{يومًا} other{يوم}}`
  String daysUnit(int count) {
    return Intl.plural(
      count,
      zero: 'يوم',
      one: 'يوم',
      two: 'يومان',
      few: 'أيام',
      many: 'يومًا',
      other: 'يوم',
      name: 'daysUnit',
      desc: '',
      args: [count],
    );
  }

  /// `مراجعة: {reviews} · جديدة: {fresh} · ~{minutes} د`
  String dueBreakdown(int reviews, int fresh, int minutes) {
    return Intl.message(
      'مراجعة: $reviews · جديدة: $fresh · ~$minutes د',
      name: 'dueBreakdown',
      desc: '',
      args: [reviews, fresh, minutes],
    );
  }

  /// `لا شيء مستحق`
  String get allCaughtUp {
    return Intl.message(
      'لا شيء مستحق',
      name: 'allCaughtUp',
      desc: '',
      args: [],
    );
  }

  /// `مجموعاتك`
  String get yourDecks {
    return Intl.message('مجموعاتك', name: 'yourDecks', desc: '', args: []);
  }

  /// `عرض الكل`
  String get seeAll {
    return Intl.message('عرض الكل', name: 'seeAll', desc: '', args: []);
  }

  /// `{count, plural, zero{لا بطاقات} one{بطاقة واحدة} two{بطاقتان} few{{count} بطاقات} many{{count} بطاقة} other{{count} بطاقة}}`
  String deckCardCount(int count) {
    return Intl.plural(
      count,
      zero: 'لا بطاقات',
      one: 'بطاقة واحدة',
      two: 'بطاقتان',
      few: '$count بطاقات',
      many: '$count بطاقة',
      other: '$count بطاقة',
      name: 'deckCardCount',
      desc: '',
      args: [count],
    );
  }

  /// `{due} مستحقة`
  String deckDueCount(int due) {
    return Intl.message(
      '$due مستحقة',
      name: 'deckDueCount',
      desc: '',
      args: [due],
    );
  }

  /// `{name}، {cards}، {due}`
  String deckTileSemantics(String name, String cards, String due) {
    return Intl.message(
      '$name، $cards، $due',
      name: 'deckTileSemantics',
      desc: '',
      args: [name, cards, due],
    );
  }

  /// `{count, plural, one{ابدأ المذاكرة · بطاقة واحدة} two{ابدأ المذاكرة · بطاقتان} few{ابدأ المذاكرة · {count} بطاقات} many{ابدأ المذاكرة · {count} بطاقة} other{ابدأ المذاكرة · {count} بطاقة}}`
  String startStudying(int count) {
    return Intl.plural(
      count,
      one: 'ابدأ المذاكرة · بطاقة واحدة',
      two: 'ابدأ المذاكرة · بطاقتان',
      few: 'ابدأ المذاكرة · $count بطاقات',
      many: 'ابدأ المذاكرة · $count بطاقة',
      other: 'ابدأ المذاكرة · $count بطاقة',
      name: 'startStudying',
      desc: '',
      args: [count],
    );
  }

  /// `أنهيت مراجعة اليوم`
  String get nothingDueButton {
    return Intl.message(
      'أنهيت مراجعة اليوم',
      name: 'nothingDueButton',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد مجموعات بعد`
  String get emptyDecksTitle {
    return Intl.message(
      'لا توجد مجموعات بعد',
      name: 'emptyDecksTitle',
      desc: '',
      args: [],
    );
  }

  /// `أنشئ مجموعة لكل مادة — مثل علم الخلية أو أسباب الحرب العالمية الأولى. ابدأ بـ 10–20 بطاقة وأضف المزيد لاحقًا.`
  String get emptyDecksBody {
    return Intl.message(
      'أنشئ مجموعة لكل مادة — مثل علم الخلية أو أسباب الحرب العالمية الأولى. ابدأ بـ 10–20 بطاقة وأضف المزيد لاحقًا.',
      name: 'emptyDecksBody',
      desc: '',
      args: [],
    );
  }

  /// `أنشئ مجموعتك الأولى`
  String get createFirstDeck {
    return Intl.message(
      'أنشئ مجموعتك الأولى',
      name: 'createFirstDeck',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get navHome {
    return Intl.message('الرئيسية', name: 'navHome', desc: '', args: []);
  }

  /// `المجموعات`
  String get navDecks {
    return Intl.message('المجموعات', name: 'navDecks', desc: '', args: []);
  }

  /// `الإحصاءات`
  String get navStats {
    return Intl.message('الإحصاءات', name: 'navStats', desc: '', args: []);
  }

  /// `الإعدادات`
  String get navSettings {
    return Intl.message('الإعدادات', name: 'navSettings', desc: '', args: []);
  }

  /// `قريبًا`
  String get comingSoon {
    return Intl.message('قريبًا', name: 'comingSoon', desc: '', args: []);
  }

  /// `المذاكرة`
  String get studyTitle {
    return Intl.message('المذاكرة', name: 'studyTitle', desc: '', args: []);
  }

  /// `الخطة اليومية`
  String get planTitle {
    return Intl.message('الخطة اليومية', name: 'planTitle', desc: '', args: []);
  }

  /// `مجموعة جديدة`
  String get deckEditTitle {
    return Intl.message(
      'مجموعة جديدة',
      name: 'deckEditTitle',
      desc: '',
      args: [],
    );
  }

  /// `المجموعة`
  String get deckDetailTitle {
    return Intl.message(
      'المجموعة',
      name: 'deckDetailTitle',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ ما. حاول مرة أخرى.`
  String get errorGeneric {
    return Intl.message(
      'حدث خطأ ما. حاول مرة أخرى.',
      name: 'errorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `إعادة المحاولة`
  String get retry {
    return Intl.message('إعادة المحاولة', name: 'retry', desc: '', args: []);
  }

  /// `اسمك (اختياري)`
  String get userNameLabel {
    return Intl.message(
      'اسمك (اختياري)',
      name: 'userNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `مثال: أمل`
  String get userNameHint {
    return Intl.message('مثال: أمل', name: 'userNameHint', desc: '', args: []);
  }

  /// `هذا الأسبوع: {done} من 7 أيام مذاكرة`
  String weekStreakSemantics(int done) {
    return Intl.message(
      'هذا الأسبوع: $done من 7 أيام مذاكرة',
      name: 'weekStreakSemantics',
      desc: '',
      args: [done],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
