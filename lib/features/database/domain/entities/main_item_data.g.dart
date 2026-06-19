// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_item_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MainItemData _$MainItemDataFromJson(Map<String, dynamic> json) =>
    _MainItemData(
      board: json['board'] as String,
      text: json['text'] as String,
      url: json['url'] as String,
      siteType: $enumDecode(_$SiteTypeEnumMap, json['siteType']),
      orderBy: (json['orderBy'] as num).toInt(),
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$MainItemDataToJson(_MainItemData instance) =>
    <String, dynamic>{
      'board': instance.board,
      'text': instance.text,
      'url': instance.url,
      'siteType': _$SiteTypeEnumMap[instance.siteType]!,
      'orderBy': instance.orderBy,
      'type': instance.type,
    };

const _$SiteTypeEnumMap = {
  SiteType.arcalive: 'arcalive',
  SiteType.bobaedream: 'bobaedream',
  SiteType.clien: 'clien',
  SiteType.cook82: 'cook82',
  SiteType.damoang: 'damoang',
  SiteType.dcinside: 'dcinside',
  SiteType.dogdrip: 'dogdrip',
  SiteType.geekNews: 'geekNews',
  SiteType.instiz: 'instiz',
  SiteType.inven: 'inven',
  SiteType.meeco: 'meeco',
  SiteType.mlbpark: 'mlbpark',
  SiteType.nate: 'nate',
  SiteType.naverCafe: 'naverCafe',
  SiteType.ppomppu: 'ppomppu',
  SiteType.reddit: 'reddit',
  SiteType.ruliweb: 'ruliweb',
  SiteType.theqoo: 'theqoo',
  SiteType.settings: 'settings',
};
