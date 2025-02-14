// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_item_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MainItemDataImpl _$$MainItemDataImplFromJson(Map<String, dynamic> json) =>
    _$MainItemDataImpl(
      board: json['board'] as String,
      text: json['text'] as String,
      url: json['url'] as String,
      siteType: $enumDecode(_$SiteTypeEnumMap, json['siteType']),
      orderBy: (json['orderBy'] as num).toInt(),
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$$MainItemDataImplToJson(_$MainItemDataImpl instance) =>
    <String, dynamic>{
      'board': instance.board,
      'text': instance.text,
      'url': instance.url,
      'siteType': _$SiteTypeEnumMap[instance.siteType]!,
      'orderBy': instance.orderBy,
      'type': instance.type,
    };

const _$SiteTypeEnumMap = {
  SiteType.clien: 'clien',
  SiteType.damoang: 'damoang',
  SiteType.meeco: 'meeco',
  SiteType.naverCafe: 'naverCafe',
  SiteType.reddit: 'reddit',
  SiteType.theqoo: 'theqoo',
  SiteType.settings: 'settings',
};
