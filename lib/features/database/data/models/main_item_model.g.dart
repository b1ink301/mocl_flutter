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
      hasItem: json['hasItem'] as bool? ?? false,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => MainItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MainItemModel>[],
    );

Map<String, dynamic> _$MainItemDataToJson(_MainItemData instance) =>
    <String, dynamic>{
      'no': instance.no,
      'board': instance.board,
      'type': instance.type,
      'title': instance.title,
      'url': instance.url,
      'siteType': _$SiteTypeEnumMap[instance.siteType],
      'hasItem': instance.hasItem,
      'children': instance.children,
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
