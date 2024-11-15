// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MainItemDataImpl _$$MainItemDataImplFromJson(Map<String, dynamic> json) =>
    _$MainItemDataImpl(
      orderBy: (json['no'] as num).toInt(),
      board: json['board'] as String,
      type: (json['type'] as num).toInt(),
      text: json['title'] as String,
      url: json['url'] as String,
      siteType: $enumDecodeNullable(_$SiteTypeEnumMap, json['siteType']),
    );

Map<String, dynamic> _$$MainItemDataImplToJson(_$MainItemDataImpl instance) =>
    <String, dynamic>{
      'no': instance.orderBy,
      'board': instance.board,
      'type': instance.type,
      'title': instance.text,
      'url': instance.url,
      'siteType': _$SiteTypeEnumMap[instance.siteType],
    };

const _$SiteTypeEnumMap = {
  SiteType.clien: 'clien',
  SiteType.damoang: 'damoang',
  SiteType.meeco: 'meeco',
  SiteType.naverCafe: 'naverCafe',
  SiteType.settings: 'settings',
};
