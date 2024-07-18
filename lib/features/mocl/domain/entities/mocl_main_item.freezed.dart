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

/// @nodoc
mixin _$MainItem {
  SiteType get siteType => throw _privateConstructorUsedError;
  String get board => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int get orderBy => throw _privateConstructorUsedError;
  bool get hasItem => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      int type,
      String text,
      String url,
      int orderBy,
      bool hasItem});
}

/// @nodoc
class _$MainItemCopyWithImpl<$Res, $Val extends MainItem>
    implements $MainItemCopyWith<$Res> {
  _$MainItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
    Object? board = null,
    Object? type = null,
    Object? text = null,
    Object? url = null,
    Object? orderBy = null,
    Object? hasItem = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
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
      hasItem: null == hasItem
          ? _value.hasItem
          : hasItem // ignore: cast_nullable_to_non_nullable
              as bool,
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
      int type,
      String text,
      String url,
      int orderBy,
      bool hasItem});
}

/// @nodoc
class __$$MainItemImplCopyWithImpl<$Res>
    extends _$MainItemCopyWithImpl<$Res, _$MainItemImpl>
    implements _$$MainItemImplCopyWith<$Res> {
  __$$MainItemImplCopyWithImpl(
      _$MainItemImpl _value, $Res Function(_$MainItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
    Object? board = null,
    Object? type = null,
    Object? text = null,
    Object? url = null,
    Object? orderBy = null,
    Object? hasItem = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
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
      hasItem: null == hasItem
          ? _value.hasItem
          : hasItem // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MainItemImpl implements _MainItem {
  const _$MainItemImpl(
      {required this.siteType,
      required this.board,
      required this.type,
      required this.text,
      required this.url,
      required this.orderBy,
      this.hasItem = false});

  @override
  final SiteType siteType;
  @override
  final String board;
  @override
  final int type;
  @override
  final String text;
  @override
  final String url;
  @override
  final int orderBy;
  @override
  @JsonKey()
  final bool hasItem;

  @override
  String toString() {
    return 'MainItem(siteType: $siteType, board: $board, type: $type, text: $text, url: $url, orderBy: $orderBy, hasItem: $hasItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainItemImpl &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType) &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.hasItem, hasItem) || other.hasItem == hasItem));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, siteType, board, type, text, url, orderBy, hasItem);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MainItemImplCopyWith<_$MainItemImpl> get copyWith =>
      __$$MainItemImplCopyWithImpl<_$MainItemImpl>(this, _$identity);
}

abstract class _MainItem implements MainItem {
  const factory _MainItem(
      {required final SiteType siteType,
      required final String board,
      required final int type,
      required final String text,
      required final String url,
      required final int orderBy,
      final bool hasItem}) = _$MainItemImpl;

  @override
  SiteType get siteType;
  @override
  String get board;
  @override
  int get type;
  @override
  String get text;
  @override
  String get url;
  @override
  int get orderBy;
  @override
  bool get hasItem;
  @override
  @JsonKey(ignore: true)
  _$$MainItemImplCopyWith<_$MainItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
