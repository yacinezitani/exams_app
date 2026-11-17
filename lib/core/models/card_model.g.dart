// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardModel _$CardModelFromJson(Map<String, dynamic> json) => CardModel(
  id: (json['id'] as num?)?.toInt(),
  deckId: (json['deck_id'] as num).toInt(),
  front: json['front'] as String,
  back: json['back'] as String,
  imagePath: json['image_path'] as String?,
  important: json['important'] == null
      ? false
      : const BoolIntConverter().fromJson((json['important'] as num).toInt()),
  ease: (json['ease'] as num?)?.toDouble() ?? 2.5,
  intervalDays: (json['interval_days'] as num?)?.toInt() ?? 0,
  dueAt: const EpochMsConverter().fromJson((json['due_at'] as num).toInt()),
  createdAt: const EpochMsConverter().fromJson(
    (json['created_at'] as num).toInt(),
  ),
);

Map<String, dynamic> _$CardModelToJson(CardModel instance) => <String, dynamic>{
  'id': ?instance.id,
  'deck_id': instance.deckId,
  'front': instance.front,
  'back': instance.back,
  'image_path': ?instance.imagePath,
  'important': const BoolIntConverter().toJson(instance.important),
  'ease': instance.ease,
  'interval_days': instance.intervalDays,
  'due_at': const EpochMsConverter().toJson(instance.dueAt),
  'created_at': const EpochMsConverter().toJson(instance.createdAt),
};
