// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_main_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MainItem _$MainItemFromJson(Map<String, dynamic> json) {
  return _MainItem.fromJson(json);
}

/// @nodoc
mixin _$MainItem {
  SiteType get siteType => throw _privateConstructorUsedError;
  String get board => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int get orderBy => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  bool get hasItem => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;

  /// Serializes this MainItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MainItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MainItemCopyWith<MainItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainItemCopyWith<$Res> {
  factory $MainItemCopyWith(MainItem value, $Res Function(MainItem) then) =
      _$MainItemCopyWithImpl<$Res, MainItem>;
  @useResult
  $Res call(
      {SiteType siteType,
      String board,
      String text,
      String url,
      int orderBy,
      int type,
      bool hasItem,
      String icon});
}

/// @nodoc
class _$MainItemCopyWithImpl<$Res, $Val extends MainItem>
    implements $MainItemCopyWith<$Res> {
  _$MainItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
    Object? board = null,
    Object? text = null,
    Object? url = null,
    Object? orderBy = null,
    Object? type = null,
    Object? hasItem = null,
    Object? icon = null,
  }) {
    return _then(_value.copyWith(
      siteType: null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
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
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      hasItem: null == hasItem
          ? _value.hasItem
          : hasItem // ignore: cast_nullable_to_non_nullable
              as bool,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MainItemImplCopyWith<$Res>
    implements $MainItemCopyWith<$Res> {
  factory _$$MainItemImplCopyWith(
          _$MainItemImpl value, $Res Function(_$MainItemImpl) then) =
      __$$MainItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SiteType siteType,
      String board,
      String text,
      String url,
      int orderBy,
      int type,
      bool hasItem,
      String icon});
}

/// @nodoc
class __$$MainItemImplCopyWithImpl<$Res>
    extends _$MainItemCopyWithImpl<$Res, _$MainItemImpl>
    implements _$$MainItemImplCopyWith<$Res> {
  __$$MainItemImplCopyWithImpl(
      _$MainItemImpl _value, $Res Function(_$MainItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
    Object? board = null,
    Object? text = null,
    Object? url = null,
    Object? orderBy = null,
    Object? type = null,
    Object? hasItem = null,
    Object? icon = null,
  }) {
    return _then(_$MainItemImpl(
      siteType: null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
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
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      hasItem: null == hasItem
          ? _value.hasItem
          : hasItem // ignore: cast_nullable_to_non_nullable
              as bool,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MainItemImpl implements _MainItem {
  const _$MainItemImpl(
      {required this.siteType,
      required this.board,
      required this.text,
      required this.url,
      required this.orderBy,
      this.type = 0,
      this.hasItem = false,
      this.icon = ''});

  factory _$MainItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MainItemImplFromJson(json);

  @override
  final SiteType siteType;
  @override
  final String board;
  @override
  final String text;
  @override
  final String url;
  @override
  final int orderBy;
  @override
  @JsonKey()
  final int type;
  @override
  @JsonKey()
  final bool hasItem;
  @override
  @JsonKey()
  final String icon;

  @override
  String toString() {
    return 'MainItem(siteType: $siteType, board: $board, text: $text, url: $url, orderBy: $orderBy, type: $type, hasItem: $hasItem, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainItemImpl &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType) &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.hasItem, hasItem) || other.hasItem == hasItem) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, siteType, board, text, url, orderBy, type, hasItem, icon);

  /// Create a copy of MainItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MainItemImplCopyWith<_$MainItemImpl> get copyWith =>
      __$$MainItemImplCopyWithImpl<_$MainItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MainItemImplToJson(
      this,
    );
  }
}

abstract class _MainItem implements MainItem {
  const factory _MainItem(
      {required final SiteType siteType,
      required final String board,
      required final String text,
      required final String url,
      required final int orderBy,
      final int type,
      final bool hasItem,
      final String icon}) = _$MainItemImpl;

  factory _MainItem.fromJson(Map<String, dynamic> json) =
      _$MainItemImpl.fromJson;

  @override
  SiteType get siteType;
  @override
  String get board;
  @override
  String get text;
  @override
  String get url;
  @override
  int get orderBy;
  @override
  int get type;
  @override
  bool get hasItem;
  @override
  String get icon;

  /// Create a copy of MainItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MainItemImplCopyWith<_$MainItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
