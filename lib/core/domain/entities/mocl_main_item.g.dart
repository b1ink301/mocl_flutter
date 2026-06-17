// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mocl_main_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MainItem _$MainItemFromJson(Map<String, dynamic> json) => _MainItem(
  siteType: $enumDecode(_$SiteTypeEnumMap, json['siteType']),
  board: json['board'] as String,
  text: json['text'] as String,
  url: json['url'] as String,
  orderBy: (json['orderBy'] as num).toInt(),
  type: (json['type'] as num?)?.toInt() ?? 0,
  hasItem: json['hasItem'] as bool? ?? false,
  icon: json['icon'] as String? ?? '',
  category: json['category'] as String? ?? '',
);

Map<String, dynamic> _$MainItemToJson(_MainItem instance) => <String, dynamic>{
  'siteType': _$SiteTypeEnumMap[instance.siteType]!,
  'board': instance.board,
  'text': instance.text,
  'url': instance.url,
  'orderBy': instance.orderBy,
  'type': instance.type,
  'hasItem': instance.hasItem,
  'icon': instance.icon,
  'category': instance.category,
};

const _$SiteTypeEnumMap = {
  SiteType.arcalive: 'arcalive',
  SiteType.bobaedream: 'bobaedream',
  SiteType.clien: 'clien',
  SiteType.cook82: 'cook82',
  SiteType.damoang: 'damoang',
  SiteType.dcinside: 'dcinside',
  SiteType.geekNews: 'geekNews',
  SiteType.inven: 'inven',
  SiteType.meeco: 'meeco',
  SiteType.naverCafe: 'naverCafe',
  SiteType.ppomppu: 'ppomppu',
  SiteType.reddit: 'reddit',
  SiteType.ruliweb: 'ruliweb',
  SiteType.theqoo: 'theqoo',
  SiteType.settings: 'settings',
};
