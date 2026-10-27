// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteGroup _$FavoriteGroupFromJson(Map<String, dynamic> json) =>
    _FavoriteGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      orderBy: (json['orderBy'] as num).toInt(),
      collapsed: json['collapsed'] as bool? ?? false,
    );

Map<String, dynamic> _$FavoriteGroupToJson(_FavoriteGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'orderBy': instance.orderBy,
      'collapsed': instance.collapsed,
    };
