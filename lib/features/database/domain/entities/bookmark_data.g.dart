// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookmarkData _$BookmarkDataFromJson(Map<String, dynamic> json) =>
    _BookmarkData(
      siteType: $enumDecode(_$SiteTypeEnumMap, json['siteType']),
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      url: json['url'] as String,
      board: json['board'] as String,
      boardTitle: json['boardTitle'] as String,
      info: json['info'] as String,
      time: json['time'] as String,
      reply: json['reply'] as String,
      userId: json['userId'] as String,
      nickName: json['nickName'] as String,
      nickImage: json['nickImage'] as String,
      savedAt: (json['savedAt'] as num).toInt(),
    );

Map<String, dynamic> _$BookmarkDataToJson(_BookmarkData instance) =>
    <String, dynamic>{
      'siteType': _$SiteTypeEnumMap[instance.siteType]!,
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'board': instance.board,
      'boardTitle': instance.boardTitle,
      'info': instance.info,
      'time': instance.time,
      'reply': instance.reply,
      'userId': instance.userId,
      'nickName': instance.nickName,
      'nickImage': instance.nickImage,
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
