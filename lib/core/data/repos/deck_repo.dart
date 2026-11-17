import 'package:exam_app/core/models/deck_summary_model.dart';
import 'package:exam_app/core/utils/result.dart';

abstract interface class DeckRepo {
  /// Decks with derived counts, most-due first. A card is due when
  /// `due_at < dueBefore`, mastered when `interval_days >= masteredIntervalDays`.
  FutureResult<List<DeckSummaryModel>> getDeckSummaries({
    required DateTime dueBefore,
    required int masteredIntervalDays,
  });
}
