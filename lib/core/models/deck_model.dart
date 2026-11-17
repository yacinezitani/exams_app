import 'package:exam_app/core/utils/sqlite_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deck_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DeckModel {
  final int? id;
  final String name;
  final String subject;

  /// ARGB colour value.
  final int color;

  @EpochMsConverter()
  final DateTime createdAt;

  const DeckModel({
    this.id,
    required this.name,
    required this.subject,
    required this.color,
    required this.createdAt,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) => _$DeckModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeckModelToJson(this);
}
