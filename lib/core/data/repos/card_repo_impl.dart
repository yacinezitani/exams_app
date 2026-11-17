import 'package:exam_app/core/data/repos/card_repo.dart';
import 'package:exam_app/core/errors/failures.dart';
import 'package:exam_app/core/models/due_summary_model.dart';
import 'package:exam_app/core/services/app_database.dart';
import 'package:exam_app/core/utils/result.dart';

class CardRepoImpl implements CardRepo {
  final AppDatabase _database;
  CardRepoImpl(this._database);

  @override
  FutureResult<DueSummaryModel> getDueSummary(DateTime dueBefore) async {
    try {
      // "New" = no study review yet. Exam-mode reviews never make a card old.
      final rows = await _database.db.rawQuery(
        '''
SELECT COUNT(*) AS due_total,
       TOTAL(CASE WHEN NOT EXISTS (
         SELECT 1 FROM reviews r WHERE r.card_id = c.id AND r.mode = ?
       ) THEN 1 ELSE 0 END) AS new_count
FROM cards c
WHERE c.due_at < ?
''',
        ['study', dueBefore.millisecondsSinceEpoch],
      );
      final row = rows.single;
      final due = row['due_total'] as int;
      final fresh = (row['new_count'] as num).toInt();
      return Ok(DueSummaryModel(reviewCount: due - fresh, newCount: fresh));
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }
}
