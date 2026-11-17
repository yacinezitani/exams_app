import 'package:exam_app/core/models/due_summary_model.dart';
import 'package:exam_app/core/utils/result.dart';

abstract interface class CardRepo {
  /// Cards with `due_at < dueBefore`, split into reviewed vs never-studied.
  FutureResult<DueSummaryModel> getDueSummary(DateTime dueBefore);
}
