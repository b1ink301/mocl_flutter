// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MainItemData _$MainItemDataFromJson(Map<String, dynamic> json) =>
    _MainItemData(
      no: (json['no'] as num).toInt(),
      board: json['board'] as String,
      type: (json['type'] as num).toInt(),
      title: json['title'] as String,
      url: json['url'] as String,
      siteType: $enumDecodeNullable(_$SiteTypeEnumMap, json['siteType']),
    );

Map<String, dynamic> _$MainItemDataToJson(_MainItemData instance) =>
    <String, dynamic>{
      'no': instance.no,
      'board': instance.board,
      'type': instance.type,
      'title': instance.title,
      'url': instance.url,
      'siteType': _$SiteTypeEnumMap[instance.siteType],
    };

const _$SiteTypeEnumMap = {
  SiteType.clien: 'clien',
  SiteType.damoang: 'damoang',
  SiteType.geekNews: 'geekNews',
  SiteType.meeco: 'meeco',
  SiteType.naverCafe: 'naverCafe',
  SiteType.reddit: 'reddit',
  SiteType.theqoo: 'theqoo',
  SiteType.settings: 'settings',
};
