// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteData _$FavoriteDataFromJson(Map<String, dynamic> json) =>
    _FavoriteData(
      siteType: $enumDecode(_$SiteTypeEnumMap, json['siteType']),
      board: json['board'] as String,
      text: json['text'] as String,
      url: json['url'] as String,
      type: (json['type'] as num).toInt(),
      icon: json['icon'] as String,
      savedAt: (json['savedAt'] as num).toInt(),
    );

Map<String, dynamic> _$FavoriteDataToJson(_FavoriteData instance) =>
    <String, dynamic>{
      'siteType': _$SiteTypeEnumMap[instance.siteType]!,
      'board': instance.board,
      'text': instance.text,
      'url': instance.url,
      'type': instance.type,
      'icon': instance.icon,
      'savedAt': instance.savedAt,
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
};
