// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserInfo {
  String get id;
  String get nickName;
  String get nickImage;
  String get nameMemo;
  String get ip;
  bool get isBlock;
  bool get isMe;
  bool get isAuthor;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserInfoCopyWith<UserInfo> get copyWith =>
      _$UserInfoCopyWithImpl<UserInfo>(this as UserInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.nickImage, nickImage) ||
                other.nickImage == nickImage) &&
            (identical(other.nameMemo, nameMemo) ||
                other.nameMemo == nameMemo) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.isBlock, isBlock) || other.isBlock == isBlock) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.isAuthor, isAuthor) ||
                other.isAuthor == isAuthor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nickName, nickImage,
      nameMemo, ip, isBlock, isMe, isAuthor);

  @override
  String toString() {
    return 'UserInfo(id: $id, nickName: $nickName, nickImage: $nickImage, nameMemo: $nameMemo, ip: $ip, isBlock: $isBlock, isMe: $isMe, isAuthor: $isAuthor)';
  }
}

/// @nodoc
abstract mixin class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) _then) =
      _$UserInfoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String nickName,
      String nickImage,
      String nameMemo,
      String ip,
      bool isBlock,
      bool isMe,
      bool isAuthor});
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res> implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._self, this._then);

  final UserInfo _self;
  final $Res Function(UserInfo) _then;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickName = null,
    Object? nickImage = null,
    Object? nameMemo = null,
    Object? ip = null,
    Object? isBlock = null,
    Object? isMe = null,
    Object? isAuthor = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickName: null == nickName
          ? _self.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      nickImage: null == nickImage
          ? _self.nickImage
          : nickImage // ignore: cast_nullable_to_non_nullable
              as String,
      nameMemo: null == nameMemo
          ? _self.nameMemo
          : nameMemo // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _self.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      isBlock: null == isBlock
          ? _self.isBlock
          : isBlock // ignore: cast_nullable_to_non_nullable
              as bool,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      isAuthor: null == isAuthor
          ? _self.isAuthor
          : isAuthor // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _UserInfo implements UserInfo {
  const _UserInfo(
      {required this.id,
      required this.nickName,
      required this.nickImage,
      this.nameMemo = '',
      this.ip = '',
      this.isBlock = false,
      this.isMe = false,
      this.isAuthor = false});

  @override
  final String id;
  @override
  final String nickName;
  @override
  final String nickImage;
  @override
  @JsonKey()
  final String nameMemo;
  @override
  @JsonKey()
  final String ip;
  @override
  @JsonKey()
  final bool isBlock;
  @override
  @JsonKey()
  final bool isMe;
  @override
  @JsonKey()
  final bool isAuthor;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserInfoCopyWith<_UserInfo> get copyWith =>
      __$UserInfoCopyWithImpl<_UserInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.nickImage, nickImage) ||
                other.nickImage == nickImage) &&
            (identical(other.nameMemo, nameMemo) ||
                other.nameMemo == nameMemo) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.isBlock, isBlock) || other.isBlock == isBlock) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.isAuthor, isAuthor) ||
                other.isAuthor == isAuthor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nickName, nickImage,
      nameMemo, ip, isBlock, isMe, isAuthor);

  @override
  String toString() {
    return 'UserInfo(id: $id, nickName: $nickName, nickImage: $nickImage, nameMemo: $nameMemo, ip: $ip, isBlock: $isBlock, isMe: $isMe, isAuthor: $isAuthor)';
  }
}

/// @nodoc
abstract mixin class _$UserInfoCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$UserInfoCopyWith(_UserInfo value, $Res Function(_UserInfo) _then) =
      __$UserInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String nickName,
      String nickImage,
      String nameMemo,
      String ip,
      bool isBlock,
      bool isMe,
      bool isAuthor});
}

/// @nodoc
class __$UserInfoCopyWithImpl<$Res> implements _$UserInfoCopyWith<$Res> {
  __$UserInfoCopyWithImpl(this._self, this._then);

  final _UserInfo _self;
  final $Res Function(_UserInfo) _then;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nickName = null,
    Object? nickImage = null,
    Object? nameMemo = null,
    Object? ip = null,
    Object? isBlock = null,
    Object? isMe = null,
    Object? isAuthor = null,
  }) {
    return _then(_UserInfo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickName: null == nickName
          ? _self.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      nickImage: null == nickImage
          ? _self.nickImage
          : nickImage // ignore: cast_nullable_to_non_nullable
              as String,
      nameMemo: null == nameMemo
          ? _self.nameMemo
          : nameMemo // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _self.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      isBlock: null == isBlock
          ? _self.isBlock
          : isBlock // ignore: cast_nullable_to_non_nullable
              as bool,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      isAuthor: null == isAuthor
          ? _self.isAuthor
          : isAuthor // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
