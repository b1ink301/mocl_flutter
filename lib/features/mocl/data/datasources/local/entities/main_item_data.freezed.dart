// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_item_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MainItemData _$MainItemDataFromJson(Map<String, dynamic> json) {
  return _MainItemData.fromJson(json);
}

/// @nodoc
mixin _$MainItemData {
  String get board => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  SiteType get siteType => throw _privateConstructorUsedError;
  int get orderBy => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;

  /// Serializes this MainItemData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MainItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MainItemDataCopyWith<MainItemData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainItemDataCopyWith<$Res> {
  factory $MainItemDataCopyWith(
          MainItemData value, $Res Function(MainItemData) then) =
      _$MainItemDataCopyWithImpl<$Res, MainItemData>;
  @useResult
  $Res call(
      {String board,
      String text,
      String url,
      SiteType siteType,
      int orderBy,
      int type});
}

/// @nodoc
class _$MainItemDataCopyWithImpl<$Res, $Val extends MainItemData>
    implements $MainItemDataCopyWith<$Res> {
  _$MainItemDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainItemData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? text = null,
    Object? url = null,
    Object? siteType = null,
    Object? orderBy = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      siteType: null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MainItemDataImplCopyWith<$Res>
    implements $MainItemDataCopyWith<$Res> {
  factory _$$MainItemDataImplCopyWith(
          _$MainItemDataImpl value, $Res Function(_$MainItemDataImpl) then) =
      __$$MainItemDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String board,
      String text,
      String url,
      SiteType siteType,
      int orderBy,
      int type});
}

/// @nodoc
class __$$MainItemDataImplCopyWithImpl<$Res>
    extends _$MainItemDataCopyWithImpl<$Res, _$MainItemDataImpl>
    implements _$$MainItemDataImplCopyWith<$Res> {
  __$$MainItemDataImplCopyWithImpl(
      _$MainItemDataImpl _value, $Res Function(_$MainItemDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainItemData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? text = null,
    Object? url = null,
    Object? siteType = null,
    Object? orderBy = null,
    Object? type = null,
  }) {
    return _then(_$MainItemDataImpl(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      siteType: null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MainItemDataImpl implements _MainItemData {
  const _$MainItemDataImpl(
      {required this.board,
      required this.text,
      required this.url,
      required this.siteType,
      required this.orderBy,
      required this.type});

  factory _$MainItemDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MainItemDataImplFromJson(json);

  @override
  final String board;
  @override
  final String text;
  @override
  final String url;
  @override
  final SiteType siteType;
  @override
  final int orderBy;
  @override
  final int type;

  @override
  String toString() {
    return 'MainItemData(board: $board, text: $text, url: $url, siteType: $siteType, orderBy: $orderBy, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainItemDataImpl &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, board, text, url, siteType, orderBy, type);

  /// Create a copy of MainItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MainItemDataImplCopyWith<_$MainItemDataImpl> get copyWith =>
      __$$MainItemDataImplCopyWithImpl<_$MainItemDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MainItemDataImplToJson(
      this,
    );
  }
}

abstract class _MainItemData implements MainItemData {
  const factory _MainItemData(
      {required final String board,
      required final String text,
      required final String url,
      required final SiteType siteType,
      required final int orderBy,
      required final int type}) = _$MainItemDataImpl;

  factory _MainItemData.fromJson(Map<String, dynamic> json) =
      _$MainItemDataImpl.fromJson;

  @override
  String get board;
  @override
  String get text;
  @override
  String get url;
  @override
  SiteType get siteType;
  @override
  int get orderBy;
  @override
  int get type;

  /// Create a copy of MainItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MainItemDataImplCopyWith<_$MainItemDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
