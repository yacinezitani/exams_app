import 'package:exam_app/core/utils/result.dart';

abstract interface class ReviewRepo {
  /// Distinct local calendar days (date-only) with at least one review.
  FutureResult<Set<DateTime>> getStudyDays();

  /// Distinct cards studied (study mode) in `[start, end)`.
  FutureResult<int> countStudiedCards({required DateTime start, required DateTime end});
}
