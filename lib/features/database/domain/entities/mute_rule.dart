import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_rule.freezed.dart';
part 'mute_rule.g.dart';

/// 뮤트 규칙의 종류. 제목 키워드 또는 작성자(닉네임) 차단.
enum MuteType() {
  keyword,
  user
}

/// 차단 규칙. sembast 의 `mutes` 스토어에 JSON 으로 저장된다(전역, 사이트 무관).
@freezed
abstract class MuteRule with _$MuteRule {
  const factory({
    required String pattern,
    required MuteType type,
    required int createdAt,
  }) = _MuteRule;

  factory fromJson(Map<String, dynamic> json) => _$MuteRuleFromJson(json);
}
