// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeckModel _$DeckModelFromJson(Map<String, dynamic> json) => DeckModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  subject: json['subject'] as String,
  color: (json['color'] as num).toInt(),
  createdAt: const EpochMsConverter().fromJson(
    (json['created_at'] as num).toInt(),
  ),
);

Map<String, dynamic> _$DeckModelToJson(DeckModel instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': instance.name,
  'subject': instance.subject,
  'color': instance.color,
  'created_at': const EpochMsConverter().toJson(instance.createdAt),
};
