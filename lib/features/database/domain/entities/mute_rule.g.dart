// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MuteRule _$MuteRuleFromJson(Map<String, dynamic> json) => _MuteRule(
  pattern: json['pattern'] as String,
  type: $enumDecode(_$MuteTypeEnumMap, json['type']),
  createdAt: (json['createdAt'] as num).toInt(),
);

Map<String, dynamic> _$MuteRuleToJson(_MuteRule instance) => <String, dynamic>{
  'pattern': instance.pattern,
  'type': _$MuteTypeEnumMap[instance.type]!,
  'createdAt': instance.createdAt,
};

const _$MuteTypeEnumMap = {MuteType.keyword: 'keyword', MuteType.user: 'user'};
