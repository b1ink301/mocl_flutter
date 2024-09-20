// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserInfo {
  String get id => throw _privateConstructorUsedError;
  String get nickName => throw _privateConstructorUsedError;
  String get nickImage => throw _privateConstructorUsedError;
  String get nameMemo => throw _privateConstructorUsedError;
  String get ip => throw _privateConstructorUsedError;
  bool get isBlock => throw _privateConstructorUsedError;
  bool get isMe => throw _privateConstructorUsedError;
  bool get isAuthor => throw _privateConstructorUsedError;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
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
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickName: null == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      nickImage: null == nickImage
          ? _value.nickImage
          : nickImage // ignore: cast_nullable_to_non_nullable
              as String,
      nameMemo: null == nameMemo
          ? _value.nameMemo
          : nameMemo // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      isBlock: null == isBlock
          ? _value.isBlock
          : isBlock // ignore: cast_nullable_to_non_nullable
              as bool,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      isAuthor: null == isAuthor
          ? _value.isAuthor
          : isAuthor // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserInfoImplCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$$UserInfoImplCopyWith(
          _$UserInfoImpl value, $Res Function(_$UserInfoImpl) then) =
      __$$UserInfoImplCopyWithImpl<$Res>;
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
class __$$UserInfoImplCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$UserInfoImpl>
    implements _$$UserInfoImplCopyWith<$Res> {
  __$$UserInfoImplCopyWithImpl(
      _$UserInfoImpl _value, $Res Function(_$UserInfoImpl) _then)
      : super(_value, _then);

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
    return _then(_$UserInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickName: null == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String,
      nickImage: null == nickImage
          ? _value.nickImage
          : nickImage // ignore: cast_nullable_to_non_nullable
              as String,
      nameMemo: null == nameMemo
          ? _value.nameMemo
          : nameMemo // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      isBlock: null == isBlock
          ? _value.isBlock
          : isBlock // ignore: cast_nullable_to_non_nullable
              as bool,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      isAuthor: null == isAuthor
          ? _value.isAuthor
          : isAuthor // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UserInfoImpl implements _UserInfo {
  const _$UserInfoImpl(
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

  @override
  String toString() {
    return 'UserInfo(id: $id, nickName: $nickName, nickImage: $nickImage, nameMemo: $nameMemo, ip: $ip, isBlock: $isBlock, isMe: $isMe, isAuthor: $isAuthor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoImpl &&
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

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      __$$UserInfoImplCopyWithImpl<_$UserInfoImpl>(this, _$identity);
}

abstract class _UserInfo implements UserInfo {
  const factory _UserInfo(
      {required final String id,
      required final String nickName,
      required final String nickImage,
      final String nameMemo,
      final String ip,
      final bool isBlock,
      final bool isMe,
      final bool isAuthor}) = _$UserInfoImpl;

  @override
  String get id;
  @override
  String get nickName;
  @override
  String get nickImage;
  @override
  String get nameMemo;
  @override
  String get ip;
  @override
  bool get isBlock;
  @override
  bool get isMe;
  @override
  bool get isAuthor;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
