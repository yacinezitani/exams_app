import 'package:exam_app/core/data/repos/deck_repo.dart';
import 'package:exam_app/core/errors/failures.dart';
import 'package:exam_app/core/models/deck_model.dart';
import 'package:exam_app/core/models/deck_summary_model.dart';
import 'package:exam_app/core/services/app_database.dart';
import 'package:exam_app/core/utils/result.dart';

class DeckRepoImpl implements DeckRepo {
  final AppDatabase _database;
  DeckRepoImpl(this._database);

  @override
  FutureResult<List<DeckSummaryModel>> getDeckSummaries({
    required DateTime dueBefore,
    required int masteredIntervalDays,
  }) async {
    try {
      // TOTAL (not SUM) returns 0.0 instead of NULL for decks with no cards.
      final rows = await _database.db.rawQuery(
        '''
SELECT d.id, d.name, d.subject, d.color, d.created_at,
       COUNT(c.id) AS card_count,
       TOTAL(CASE WHEN c.due_at < ? THEN 1 ELSE 0 END) AS due_count,
       TOTAL(CASE WHEN c.interval_days >= ? THEN 1 ELSE 0 END) AS mastered_count
FROM decks d
LEFT JOIN cards c ON c.deck_id = d.id
GROUP BY d.id
ORDER BY due_count DESC, d.created_at ASC, d.id ASC
''',
        [dueBefore.millisecondsSinceEpoch, masteredIntervalDays],
      );
      return Ok([
        for (final row in rows)
          DeckSummaryModel(
            deck: DeckModel.fromJson(row),
            cardCount: row['card_count'] as int,
            dueCount: (row['due_count'] as num).toInt(),
            masteredCount: (row['mastered_count'] as num).toInt(),
          ),
      ]);
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }
}
