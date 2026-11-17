import 'package:exam_app/core/models/card_model.dart';
import 'package:exam_app/core/models/deck_model.dart';
import 'package:exam_app/core/models/review_log_model.dart';
import 'package:exam_app/core/services/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// In-memory database with the real schema.
Future<AppDatabase> openTestDatabase() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  return AppDatabase.open(path: inMemoryDatabasePath);
}

Future<int> insertDeck(AppDatabase db, String name, {DateTime? at}) => db.db.insert(
      'decks',
      DeckModel(
        name: name,
        subject: 'Biology',
        color: 0xFF4F46E5,
        createdAt: at ?? DateTime(2026, 11, 1),
      ).toJson(),
    );

Future<int> insertCard(
  AppDatabase db,
  int deckId, {
  required DateTime dueAt,
  int intervalDays = 0,
}) =>
    db.db.insert(
      'cards',
      CardModel(
        deckId: deckId,
        front: 'Q',
        back: 'A',
        intervalDays: intervalDays,
        dueAt: dueAt,
        createdAt: DateTime(2026, 11, 1),
      ).toJson(),
    );

Future<int> insertReview(
  AppDatabase db,
  int cardId,
  DateTime at, {
  ReviewMode mode = ReviewMode.study,
}) =>
    db.db.insert(
      'reviews',
      ReviewLogModel(cardId: cardId, rating: 2, reviewedAt: at, mode: mode).toJson(),
    );
