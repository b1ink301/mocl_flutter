import 'package:freezed_annotation/freezed_annotation.dart';

part 'mocl_user_info.freezed.dart';

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String id,
    required String nickName,
    required String nickImage,
    @Default('') String nameMemo,
    @Default('') String ip,
    @Default(false) bool isBlock,
    @Default(false) bool isMe,
    @Default(false) bool isAuthor,
  }) = _UserInfo;

  factory UserInfo.empty() =>
      const UserInfo(id: '', nickName: '', nickImage: '');
}
