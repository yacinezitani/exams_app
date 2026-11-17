import 'package:exam_app/core/utils/sqlite_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_log_model.g.dart';

enum ReviewMode {
  @JsonValue('study')
  study,
  @JsonValue('exam')
  exam,
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ReviewLogModel {
  final int? id;
  final int cardId;

  /// 0 = Again, 1 = Hard, 2 = Good, 3 = Easy.
  final int rating;

  @EpochMsConverter()
  final DateTime reviewedAt;
  final ReviewMode mode;

  const ReviewLogModel({
    this.id,
    required this.cardId,
    required this.rating,
    required this.reviewedAt,
    this.mode = ReviewMode.study,
  });

  factory ReviewLogModel.fromJson(Map<String, dynamic> json) => _$ReviewLogModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewLogModelToJson(this);
}
