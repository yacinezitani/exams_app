// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(count) =>
      "${Intl.plural(count, zero: 'بطاقة', one: 'بطاقة', two: 'بطاقتان', few: 'بطاقات', many: 'بطاقة', other: 'بطاقة')}";

  static String m1(exam, date) => "${exam} · ${date}";

  static String m2(days) =>
      "${Intl.plural(days, zero: 'يوم متبقٍ', one: 'يوم متبقٍ', two: 'يومان متبقيان', few: 'أيام متبقية', many: 'يومًا متبقيًا', other: 'يوم متبقٍ')}";

  static String m3(count) =>
      "${Intl.plural(count, zero: 'يوم', one: 'يوم', two: 'يومان', few: 'أيام', many: 'يومًا', other: 'يوم')}";

  static String m4(count) =>
      "${Intl.plural(count, zero: 'لا بطاقات', one: 'بطاقة واحدة', two: 'بطاقتان', few: '${count} بطاقات', many: '${count} بطاقة', other: '${count} بطاقة')}";

  static String m5(due) => "${due} مستحقة";

  static String m6(name, cards, due) => "${name}، ${cards}، ${due}";

  static String m7(reviews, fresh, minutes) =>
      "مراجعة: ${reviews} · جديدة: ${fresh} · ~${minutes} د";

  static String m8(date, days) =>
      "${date} · ${Intl.plural(days, zero: 'اليوم', one: 'باقٍ يوم واحد', two: 'باقٍ يومان', few: 'باقٍ ${days} أيام', many: 'باقٍ ${days} يومًا', other: 'باقٍ ${days} يوم')}";

  static String m9(minutes) =>
      "${Intl.plural(minutes, few: 'حوالي ${minutes} دقائق يوميًا', many: 'حوالي ${minutes} دقيقة يوميًا', other: 'حوالي ${minutes} دقيقة يوميًا')}";

  static String m10(reviews, exam, date) =>
      "حوالي ${reviews} قبل ${exam} في ${date}.";

  static String m11(count) =>
      "${Intl.plural(count, zero: 'لا مراجعات', one: 'مراجعة واحدة', two: 'مراجعتان', few: '${count} مراجعات', many: '${count} مراجعة', other: '${count} مراجعة')}";

  static String m12(greeting, name) => "${greeting}، ${name}";

  static String m13(weekday, date) => "${weekday}، ${date}";

  static String m14(exam) => "تستعد لـ ${exam}";

  static String m15(name) => "أهلًا، ${name}";

  static String m16(percent, status) => "الخطة ${percent}% مكتملة · ${status}";

  static String m17(count) =>
      "${Intl.plural(count, one: 'ابدأ المذاكرة · بطاقة واحدة', two: 'ابدأ المذاكرة · بطاقتان', few: 'ابدأ المذاكرة · ${count} بطاقات', many: 'ابدأ المذاكرة · ${count} بطاقة', other: 'ابدأ المذاكرة · ${count} بطاقة')}";

  static String m18(step, total) => "الخطوة ${step} من ${total}";

  static String m19(done) => "هذا الأسبوع: ${done} من 7 أيام مذاكرة";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "allCaughtUp": MessageLookupByLibrary.simpleMessage("لا شيء مستحق"),
    "appName": MessageLookupByLibrary.simpleMessage("ريكول"),
    "back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "cardsUnit": m0,
    "comingSoon": MessageLookupByLibrary.simpleMessage("قريبًا"),
    "continueLabel": MessageLookupByLibrary.simpleMessage("متابعة"),
    "countdownLabel": m1,
    "createFirstDeck": MessageLookupByLibrary.simpleMessage(
      "أنشئ مجموعتك الأولى",
    ),
    "dailyPlanLink": MessageLookupByLibrary.simpleMessage("الخطة اليومية"),
    "daysToGoUnit": m2,
    "daysUnit": m3,
    "deckCardCount": m4,
    "deckDetailTitle": MessageLookupByLibrary.simpleMessage("المجموعة"),
    "deckDueCount": m5,
    "deckEditTitle": MessageLookupByLibrary.simpleMessage("مجموعة جديدة"),
    "deckTileSemantics": m6,
    "dueBreakdown": m7,
    "dueTodayLabel": MessageLookupByLibrary.simpleMessage("مستحقة اليوم"),
    "emptyCountdownHint": MessageLookupByLibrary.simpleMessage(
      "أضف مجموعة وسنبني لك خطتك اليومية.",
    ),
    "emptyDecksBody": MessageLookupByLibrary.simpleMessage(
      "أنشئ مجموعة لكل مادة — مثل علم الخلية أو أسباب الحرب العالمية الأولى. ابدأ بـ 10–20 بطاقة وأضف المزيد لاحقًا.",
    ),
    "emptyDecksTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد مجموعات بعد",
    ),
    "errorGeneric": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. حاول مرة أخرى.",
    ),
    "examCountdown": m8,
    "examDateLabel": MessageLookupByLibrary.simpleMessage("تاريخ الامتحان"),
    "examDayToday": MessageLookupByLibrary.simpleMessage(
      "يوم الامتحان — بالتوفيق",
    ),
    "examNameHint": MessageLookupByLibrary.simpleMessage(
      "مثال: امتحان الأحياء النهائي",
    ),
    "examNameLabel": MessageLookupByLibrary.simpleMessage("اسم الامتحان"),
    "examPassedTitle": MessageLookupByLibrary.simpleMessage(
      "انتهى موعد امتحانك",
    ),
    "examSetupSubtitle": MessageLookupByLibrary.simpleMessage(
      "سنعدّ الأيام تنازليًا ونوزّع بطاقاتك على الأيام المتبقية.",
    ),
    "examSetupTitle": MessageLookupByLibrary.simpleMessage("لأي امتحان تستعد؟"),
    "getStarted": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
    "goalFocused": MessageLookupByLibrary.simpleMessage("مركّز"),
    "goalIntense": MessageLookupByLibrary.simpleMessage("مكثّف"),
    "goalLight": MessageLookupByLibrary.simpleMessage("خفيف"),
    "goalMinutes": m9,
    "goalSteady": MessageLookupByLibrary.simpleMessage("متوازن"),
    "goalSubtitle": MessageLookupByLibrary.simpleMessage(
      "كم بطاقة في اليوم تراها مناسبة؟ يمكنك تغيير ذلك في أي وقت.",
    ),
    "goalSummary": m10,
    "goalSummaryReviews": m11,
    "goalTitle": MessageLookupByLibrary.simpleMessage("اختر هدفك اليومي"),
    "greetingAfternoon": MessageLookupByLibrary.simpleMessage("مساء الخير"),
    "greetingEvening": MessageLookupByLibrary.simpleMessage("مساء الخير"),
    "greetingMorning": MessageLookupByLibrary.simpleMessage("صباح الخير"),
    "greetingWithName": m12,
    "homeDate": m13,
    "homePlaceholder": m14,
    "homeWelcome": MessageLookupByLibrary.simpleMessage("أهلًا بك"),
    "homeWelcomeNamed": m15,
    "navDecks": MessageLookupByLibrary.simpleMessage("المجموعات"),
    "navHome": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "navSettings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "navStats": MessageLookupByLibrary.simpleMessage("الإحصاءات"),
    "nextMonth": MessageLookupByLibrary.simpleMessage("الشهر التالي"),
    "nothingDueButton": MessageLookupByLibrary.simpleMessage(
      "أنهيت مراجعة اليوم",
    ),
    "planStatusBehind": MessageLookupByLibrary.simpleMessage("متأخر قليلًا"),
    "planStatusDone": MessageLookupByLibrary.simpleMessage("أنجزت هدف اليوم"),
    "planStatusOnTrack": MessageLookupByLibrary.simpleMessage(
      "في المسار الصحيح",
    ),
    "planSummary": m16,
    "planTitle": MessageLookupByLibrary.simpleMessage("الخطة اليومية"),
    "previousMonth": MessageLookupByLibrary.simpleMessage("الشهر السابق"),
    "recommended": MessageLookupByLibrary.simpleMessage("موصى به"),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "sampleQuestion": MessageLookupByLibrary.simpleMessage(
      "في أي عام بدأت الثورة الفرنسية؟",
    ),
    "sampleQuestionLabel": MessageLookupByLibrary.simpleMessage("سؤال"),
    "sampleSubject": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "saveError": MessageLookupByLibrary.simpleMessage(
      "تعذّر حفظ إعداداتك. حاول مرة أخرى.",
    ),
    "seeAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
    "setNewDate": MessageLookupByLibrary.simpleMessage("حدّد تاريخًا جديدًا"),
    "startLearning": MessageLookupByLibrary.simpleMessage("ابدأ التعلّم"),
    "startStudying": m17,
    "stepOfTotal": m18,
    "streakLabel": MessageLookupByLibrary.simpleMessage("أيام متتالية"),
    "studyTitle": MessageLookupByLibrary.simpleMessage("المذاكرة"),
    "userNameHint": MessageLookupByLibrary.simpleMessage("مثال: أمل"),
    "userNameLabel": MessageLookupByLibrary.simpleMessage("اسمك (اختياري)"),
    "weekStreakSemantics": m19,
    "welcomeBody": MessageLookupByLibrary.simpleMessage(
      "أنشئ بطاقات، اقلبها، ودع البطاقات التي أخطأت فيها تعود إليك أسرع. سنخطط لك القليل كل يوم حتى موعد امتحانك.",
    ),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage(
      "ذاكر بذكاء ليوم الامتحان",
    ),
    "yourDecks": MessageLookupByLibrary.simpleMessage("مجموعاتك"),
  };
}
