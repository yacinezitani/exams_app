// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewLogModel _$ReviewLogModelFromJson(Map<String, dynamic> json) =>
    ReviewLogModel(
      id: (json['id'] as num?)?.toInt(),
      cardId: (json['card_id'] as num).toInt(),
      rating: (json['rating'] as num).toInt(),
      reviewedAt: const EpochMsConverter().fromJson(
        (json['reviewed_at'] as num).toInt(),
      ),
      mode:
          $enumDecodeNullable(_$ReviewModeEnumMap, json['mode']) ??
          ReviewMode.study,
    );

Map<String, dynamic> _$ReviewLogModelToJson(ReviewLogModel instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'card_id': instance.cardId,
      'rating': instance.rating,
      'reviewed_at': const EpochMsConverter().toJson(instance.reviewedAt),
      'mode': _$ReviewModeEnumMap[instance.mode]!,
    };

const _$ReviewModeEnumMap = {
  ReviewMode.study: 'study',
  ReviewMode.exam: 'exam',
};
