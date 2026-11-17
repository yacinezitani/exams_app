import 'package:exam_app/core/utils/sqlite_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CardModel {
  final int? id;
  final int deckId;
  final String front;
  final String back;

  /// Path relative to the app documents directory.
  final String? imagePath;

  @BoolIntConverter()
  final bool important;
  final double ease;
  final int intervalDays;

  @EpochMsConverter()
  final DateTime dueAt;

  @EpochMsConverter()
  final DateTime createdAt;

  const CardModel({
    this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.imagePath,
    this.important = false,
    this.ease = 2.5,
    this.intervalDays = 0,
    required this.dueAt,
    required this.createdAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);
  Map<String, dynamic> toJson() => _$CardModelToJson(this);
}
