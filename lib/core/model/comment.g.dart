// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotComment _$SpotCommentFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SpotComment',
      json,
      ($checkedConvert) {
        final val = SpotComment(
          comment: $checkedConvert('comment', (v) => v as String),
          createdAt: $checkedConvert('created_at', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {'createdAt': 'created_at'},
    );

Map<String, dynamic> _$SpotCommentToJson(SpotComment instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'created_at': instance.createdAt,
    };
