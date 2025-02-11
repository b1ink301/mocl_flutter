// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mocl_main_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MainItemImpl _$$MainItemImplFromJson(Map<String, dynamic> json) =>
    _$MainItemImpl(
      siteType: $enumDecode(_$SiteTypeEnumMap, json['siteType']),
      board: json['board'] as String,
      text: json['text'] as String,
      url: json['url'] as String,
      orderBy: (json['orderBy'] as num).toInt(),
      type: (json['type'] as num?)?.toInt() ?? 0,
      hasItem: json['hasItem'] as bool? ?? false,
      icon: json['icon'] as String? ?? '',
    );

Map<String, dynamic> _$$MainItemImplToJson(_$MainItemImpl instance) =>
    <String, dynamic>{
      'siteType': _$SiteTypeEnumMap[instance.siteType]!,
      'board': instance.board,
      'text': instance.text,
      'url': instance.url,
      'orderBy': instance.orderBy,
      'type': instance.type,
      'hasItem': instance.hasItem,
      'icon': instance.icon,
    };

const _$SiteTypeEnumMap = {
  SiteType.clien: 'clien',
  SiteType.damoang: 'damoang',
  SiteType.meeco: 'meeco',
  SiteType.naverCafe: 'naverCafe',
  SiteType.reddit: 'reddit',
  SiteType.settings: 'settings',
};
