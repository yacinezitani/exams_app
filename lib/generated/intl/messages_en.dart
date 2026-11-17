// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, one: 'card', other: 'cards')}";

  static String m1(exam, date) => "${exam} · ${date}";

  static String m2(days) =>
      "${Intl.plural(days, one: 'day to go', other: 'days to go')}";

  static String m3(count) => "${Intl.plural(count, one: 'day', other: 'days')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 card', other: '${count} cards')}";

  static String m5(due) => "${due} due";

  static String m6(name, cards, due) => "${name}, ${cards}, ${due}";

  static String m7(reviews, fresh, minutes) =>
      "${reviews} reviews · ${fresh} new · ~${minutes} min";

  static String m8(date, days) =>
      "${date} · ${Intl.plural(days, zero: 'today', one: '1 day to go', other: '${days} days to go')}";

  static String m9(minutes) => "About ${minutes} min a day";

  static String m10(reviews, exam, date) =>
      "About ${reviews} before your ${exam} on ${date}.";

  static String m11(count) =>
      "${Intl.plural(count, one: '1 review', other: '${count} reviews')}";

  static String m12(greeting, name) => "${greeting}, ${name}";

  static String m13(weekday, date) => "${weekday}, ${date}";

  static String m14(exam) => "Preparing for ${exam}";

  static String m15(name) => "Welcome, ${name}";

  static String m16(percent, status) => "Plan ${percent}% done · ${status}";

  static String m17(count) =>
      "${Intl.plural(count, one: 'Start studying · 1 card', other: 'Start studying · ${count} cards')}";

  static String m18(step, total) => "Step ${step} of ${total}";

  static String m19(done) => "This week: ${done} of 7 days studied";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "allCaughtUp": MessageLookupByLibrary.simpleMessage("All caught up"),
    "appName": MessageLookupByLibrary.simpleMessage("Recall"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "cardsUnit": m0,
    "comingSoon": MessageLookupByLibrary.simpleMessage("Coming soon"),
    "continueLabel": MessageLookupByLibrary.simpleMessage("Continue"),
    "countdownLabel": m1,
    "createFirstDeck": MessageLookupByLibrary.simpleMessage(
      "Create your first deck",
    ),
    "dailyPlanLink": MessageLookupByLibrary.simpleMessage("Daily plan"),
    "daysToGoUnit": m2,
    "daysUnit": m3,
    "deckCardCount": m4,
    "deckDetailTitle": MessageLookupByLibrary.simpleMessage("Deck"),
    "deckDueCount": m5,
    "deckEditTitle": MessageLookupByLibrary.simpleMessage("New deck"),
    "deckTileSemantics": m6,
    "dueBreakdown": m7,
    "dueTodayLabel": MessageLookupByLibrary.simpleMessage("Due today"),
    "emptyCountdownHint": MessageLookupByLibrary.simpleMessage(
      "Add a deck and we’ll build your daily plan.",
    ),
    "emptyDecksBody": MessageLookupByLibrary.simpleMessage(
      "Make one deck per subject — like Cell Biology or WWI Causes. Start with 10–20 cards; you can add more later.",
    ),
    "emptyDecksTitle": MessageLookupByLibrary.simpleMessage("No decks yet"),
    "errorGeneric": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "examCountdown": m8,
    "examDateLabel": MessageLookupByLibrary.simpleMessage("Exam date"),
    "examDayToday": MessageLookupByLibrary.simpleMessage(
      "Exam day — good luck",
    ),
    "examNameHint": MessageLookupByLibrary.simpleMessage("e.g. Biology Final"),
    "examNameLabel": MessageLookupByLibrary.simpleMessage("Exam name"),
    "examPassedTitle": MessageLookupByLibrary.simpleMessage(
      "Your exam date has passed",
    ),
    "examSetupSubtitle": MessageLookupByLibrary.simpleMessage(
      "We’ll count down and spread your cards across the days left.",
    ),
    "examSetupTitle": MessageLookupByLibrary.simpleMessage(
      "What are you studying for?",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("Get started"),
    "goalFocused": MessageLookupByLibrary.simpleMessage("Focused"),
    "goalIntense": MessageLookupByLibrary.simpleMessage("Intense"),
    "goalLight": MessageLookupByLibrary.simpleMessage("Light"),
    "goalMinutes": m9,
    "goalSteady": MessageLookupByLibrary.simpleMessage("Steady"),
    "goalSubtitle": MessageLookupByLibrary.simpleMessage(
      "How many cards a day feels doable? You can change this any time.",
    ),
    "goalSummary": m10,
    "goalSummaryReviews": m11,
    "goalTitle": MessageLookupByLibrary.simpleMessage("Pick a daily goal"),
    "greetingAfternoon": MessageLookupByLibrary.simpleMessage("Good afternoon"),
    "greetingEvening": MessageLookupByLibrary.simpleMessage("Good evening"),
    "greetingMorning": MessageLookupByLibrary.simpleMessage("Good morning"),
    "greetingWithName": m12,
    "homeDate": m13,
    "homePlaceholder": m14,
    "homeWelcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "homeWelcomeNamed": m15,
    "navDecks": MessageLookupByLibrary.simpleMessage("Decks"),
    "navHome": MessageLookupByLibrary.simpleMessage("Home"),
    "navSettings": MessageLookupByLibrary.simpleMessage("Settings"),
    "navStats": MessageLookupByLibrary.simpleMessage("Stats"),
    "nextMonth": MessageLookupByLibrary.simpleMessage("Next month"),
    "nothingDueButton": MessageLookupByLibrary.simpleMessage(
      "All caught up for today",
    ),
    "planStatusBehind": MessageLookupByLibrary.simpleMessage("a little behind"),
    "planStatusDone": MessageLookupByLibrary.simpleMessage("today’s goal met"),
    "planStatusOnTrack": MessageLookupByLibrary.simpleMessage("on track"),
    "planSummary": m16,
    "planTitle": MessageLookupByLibrary.simpleMessage("Daily plan"),
    "previousMonth": MessageLookupByLibrary.simpleMessage("Previous month"),
    "recommended": MessageLookupByLibrary.simpleMessage("Recommended"),
    "retry": MessageLookupByLibrary.simpleMessage("Try again"),
    "sampleQuestion": MessageLookupByLibrary.simpleMessage(
      "In what year did the French Revolution begin?",
    ),
    "sampleQuestionLabel": MessageLookupByLibrary.simpleMessage("QUESTION"),
    "sampleSubject": MessageLookupByLibrary.simpleMessage("History"),
    "saveError": MessageLookupByLibrary.simpleMessage(
      "Couldn’t save your settings. Please try again.",
    ),
    "seeAll": MessageLookupByLibrary.simpleMessage("See all"),
    "setNewDate": MessageLookupByLibrary.simpleMessage("Set a new date"),
    "startLearning": MessageLookupByLibrary.simpleMessage("Start learning"),
    "startStudying": m17,
    "stepOfTotal": m18,
    "streakLabel": MessageLookupByLibrary.simpleMessage("Streak"),
    "studyTitle": MessageLookupByLibrary.simpleMessage("Study"),
    "userNameHint": MessageLookupByLibrary.simpleMessage("e.g. Amira"),
    "userNameLabel": MessageLookupByLibrary.simpleMessage(
      "Your name (optional)",
    ),
    "weekStreakSemantics": m19,
    "welcomeBody": MessageLookupByLibrary.simpleMessage(
      "Make flashcards, flip through them, and let missed cards come back sooner. We’ll plan a little each day until your exam.",
    ),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage(
      "Study smarter for exam day",
    ),
    "yourDecks": MessageLookupByLibrary.simpleMessage("Your decks"),
  };
}
