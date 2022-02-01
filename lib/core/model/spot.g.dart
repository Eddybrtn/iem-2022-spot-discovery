// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Spot _$SpotFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Spot',
      json,
      ($checkedConvert) {
        final val = Spot(
          id: $checkedConvert('id', (v) => v as int),
          title: $checkedConvert('title', (v) => v as String?),
          trainStation: $checkedConvert('train_station', (v) => v as String?),
          address: $checkedConvert('address', (v) => v as String?),
          latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
          imageFullsize: $checkedConvert('image_fullsize', (v) => v as String?),
          imageThumbnail:
              $checkedConvert('image_thumbnail', (v) => v as String?),
          isRecommended: $checkedConvert('is_recommended', (v) => v as bool?),
          isClosed: $checkedConvert('is_closed', (v) => v as bool?),
          mainCategory: $checkedConvert(
              'main_category',
              (v) => v == null
                  ? null
                  : SpotCategory.fromJson(v as Map<String, dynamic>)),
          tagsCategory: $checkedConvert(
              'tags_category',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => SpotCategory.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        $checkedConvert('description', (v) => val.description = v as String?);
        $checkedConvert(
            'images_collection',
            (v) => val.imagesCollection =
                (v as List<dynamic>?)?.map((e) => e as String).toList());
        $checkedConvert(
            'comments', (v) => val.commentsMap = v as Map<String, dynamic>?);
        return val;
      },
      fieldKeyMap: const {
        'trainStation': 'train_station',
        'imageFullsize': 'image_fullsize',
        'imageThumbnail': 'image_thumbnail',
        'isRecommended': 'is_recommended',
        'isClosed': 'is_closed',
        'mainCategory': 'main_category',
        'tagsCategory': 'tags_category',
        'imagesCollection': 'images_collection',
        'commentsMap': 'comments'
      },
    );

Map<String, dynamic> _$SpotToJson(Spot instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'train_station': instance.trainStation,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image_fullsize': instance.imageFullsize,
      'image_thumbnail': instance.imageThumbnail,
      'is_recommended': instance.isRecommended,
      'is_closed': instance.isClosed,
      'main_category': instance.mainCategory?.toJson(),
      'tags_category': instance.tagsCategory?.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'images_collection': instance.imagesCollection,
      'comments': instance.commentsMap,
    };
