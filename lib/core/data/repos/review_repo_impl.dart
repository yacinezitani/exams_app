import 'package:exam_app/core/data/repos/review_repo.dart';
import 'package:exam_app/core/errors/failures.dart';
import 'package:exam_app/core/services/app_database.dart';
import 'package:exam_app/core/utils/result.dart';
import 'package:sqflite/sqflite.dart';

class ReviewRepoImpl implements ReviewRepo {
  final AppDatabase _database;
  ReviewRepoImpl(this._database);

  @override
  FutureResult<Set<DateTime>> getStudyDays() async {
    try {
      final rows = await _database.db.rawQuery(
        "SELECT DISTINCT date(reviewed_at / 1000, 'unixepoch', 'localtime') AS day "
        'FROM reviews',
      );
      return Ok({
        for (final row in rows) DateTime.parse(row['day'] as String),
      });
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }

  @override
  FutureResult<int> countStudiedCards({
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final count = Sqflite.firstIntValue(await _database.db.rawQuery(
        'SELECT COUNT(DISTINCT card_id) FROM reviews '
        'WHERE mode = ? AND reviewed_at >= ? AND reviewed_at < ?',
        ['study', start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      ));
      return Ok(count ?? 0);
    } catch (e) {
      return Err(Failure.failureFromException(e));
    }
  }
}
