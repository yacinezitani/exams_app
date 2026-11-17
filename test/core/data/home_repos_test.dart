import 'package:exam_app/core/data/repos/card_repo_impl.dart';
import 'package:exam_app/core/data/repos/deck_repo_impl.dart';
import 'package:exam_app/core/data/repos/review_repo_impl.dart';
import 'package:exam_app/core/models/review_log_model.dart';
import 'package:exam_app/core/services/app_database.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  final tomorrow = DateTime(2026, 11, 18);
  final today = DateTime(2026, 11, 17);

  setUp(() async => db = await openTestDatabase());
  tearDown(() => db.close());

  group('DeckRepo', () {
    test('counts cards, due and mastered per deck, most due first', () async {
      final calm = await insertDeck(db, 'Calm', at: DateTime(2026, 11, 1));
      final busy = await insertDeck(db, 'Busy', at: DateTime(2026, 11, 2));
      await insertCard(db, calm, dueAt: DateTime(2026, 11, 25), intervalDays: 10);
      await insertCard(db, busy, dueAt: DateTime(2026, 11, 17));
      await insertCard(db, busy, dueAt: DateTime(2026, 11, 16, 9), intervalDays: 8);
      await insertCard(db, busy, dueAt: DateTime(2026, 11, 30), intervalDays: 3);

      final result = await DeckRepoImpl(db)
          .getDeckSummaries(dueBefore: tomorrow, masteredIntervalDays: 7);
      final decks = result.valueOrNull!;

      expect(decks.map((d) => d.deck.name), ['Busy', 'Calm']);
      expect(decks[0].cardCount, 3);
      expect(decks[0].dueCount, 2);
      expect(decks[0].masteredCount, 1);
      expect(decks[0].mastery, closeTo(1 / 3, 1e-9));
      expect(decks[1].dueCount, 0);
      expect(decks[1].masteredCount, 1);
    });

    test('a deck with no cards has zero counts and zero mastery', () async {
      await insertDeck(db, 'Empty');
      final deck = (await DeckRepoImpl(db)
              .getDeckSummaries(dueBefore: tomorrow, masteredIntervalDays: 7))
          .valueOrNull!
          .single;
      expect([deck.cardCount, deck.dueCount, deck.masteredCount], [0, 0, 0]);
      expect(deck.mastery, 0);
    });

    test('deleting a deck cascades to cards and reviews', () async {
      final deck = await insertDeck(db, 'Gone');
      final card = await insertCard(db, deck, dueAt: today);
      await insertReview(db, card, today);

      await db.db.delete('decks', where: 'id = ?', whereArgs: [deck]);

      expect(await db.db.query('cards'), isEmpty);
      expect(await db.db.query('reviews'), isEmpty);
    });
  });

  group('CardRepo', () {
    test('splits due cards into new and reviewed; exam reviews keep a card new', () async {
      final deck = await insertDeck(db, 'D');
      final fresh = await insertCard(db, deck, dueAt: today);
      final examOnly = await insertCard(db, deck, dueAt: today);
      final studied = await insertCard(db, deck, dueAt: today, intervalDays: 1);
      await insertCard(db, deck, dueAt: DateTime(2026, 11, 20)); // not due
      await insertReview(db, examOnly, today, mode: ReviewMode.exam);
      await insertReview(db, studied, DateTime(2026, 11, 16));
      expect(fresh, isNonZero);

      final due = (await CardRepoImpl(db).getDueSummary(tomorrow)).valueOrNull!;

      expect(due.newCount, 2);
      expect(due.reviewCount, 1);
      expect(due.total, 3);
    });

    test('no cards means nothing due', () async {
      final due = (await CardRepoImpl(db).getDueSummary(tomorrow)).valueOrNull!;
      expect(due.total, 0);
    });
  });

  group('ReviewRepo', () {
    test('study days are distinct local dates across both modes', () async {
      final deck = await insertDeck(db, 'D');
      final card = await insertCard(db, deck, dueAt: today);
      await insertReview(db, card, DateTime(2026, 11, 15, 9));
      await insertReview(db, card, DateTime(2026, 11, 15, 21));
      await insertReview(db, card, DateTime(2026, 11, 16, 12), mode: ReviewMode.exam);

      final days = (await ReviewRepoImpl(db).getStudyDays()).valueOrNull!;

      expect(days, {DateTime(2026, 11, 15), DateTime(2026, 11, 16)});
    });

    test('studied-today counts distinct study cards in range and ignores exam mode', () async {
      final deck = await insertDeck(db, 'D');
      final a = await insertCard(db, deck, dueAt: today);
      final b = await insertCard(db, deck, dueAt: today);
      await insertReview(db, a, DateTime(2026, 11, 17, 8));
      await insertReview(db, a, DateTime(2026, 11, 17, 9));
      await insertReview(db, b, DateTime(2026, 11, 17, 10), mode: ReviewMode.exam);
      await insertReview(db, b, DateTime(2026, 11, 16, 23));

      final count = (await ReviewRepoImpl(db)
              .countStudiedCards(start: today, end: tomorrow))
          .valueOrNull!;

      expect(count, 1);
    });
  });
}
