// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MainItemModel _$MainItemModelFromJson(Map<String, dynamic> json) {
  return _MainItemData.fromJson(json);
}

/// @nodoc
mixin _$MainItemModel {
  @JsonKey(name: 'no')
  int get orderBy => throw _privateConstructorUsedError;
  String get board => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get text => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  SiteType? get siteType => throw _privateConstructorUsedError;

  /// Serializes this MainItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MainItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MainItemModelCopyWith<MainItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainItemModelCopyWith<$Res> {
  factory $MainItemModelCopyWith(
          MainItemModel value, $Res Function(MainItemModel) then) =
      _$MainItemModelCopyWithImpl<$Res, MainItemModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'no') int orderBy,
      String board,
      int type,
      @JsonKey(name: 'title') String text,
      String url,
      SiteType? siteType});
}

/// @nodoc
class _$MainItemModelCopyWithImpl<$Res, $Val extends MainItemModel>
    implements $MainItemModelCopyWith<$Res> {
  _$MainItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderBy = null,
    Object? board = null,
    Object? type = null,
    Object? text = null,
    Object? url = null,
    Object? siteType = freezed,
  }) {
    return _then(_value.copyWith(
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as int,
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
      siteType: freezed == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MainItemDataImplCopyWith<$Res>
    implements $MainItemModelCopyWith<$Res> {
  factory _$$MainItemDataImplCopyWith(
          _$MainItemDataImpl value, $Res Function(_$MainItemDataImpl) then) =
      __$$MainItemDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'no') int orderBy,
      String board,
      int type,
      @JsonKey(name: 'title') String text,
      String url,
      SiteType? siteType});
}

/// @nodoc
class __$$MainItemDataImplCopyWithImpl<$Res>
    extends _$MainItemModelCopyWithImpl<$Res, _$MainItemDataImpl>
    implements _$$MainItemDataImplCopyWith<$Res> {
  __$$MainItemDataImplCopyWithImpl(
      _$MainItemDataImpl _value, $Res Function(_$MainItemDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderBy = null,
    Object? board = null,
    Object? type = null,
    Object? text = null,
    Object? url = null,
    Object? siteType = freezed,
  }) {
    return _then(_$MainItemDataImpl(
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as int,
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
      siteType: freezed == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MainItemDataImpl implements _MainItemData {
  const _$MainItemDataImpl(
      {@JsonKey(name: 'no') required this.orderBy,
      required this.board,
      required this.type,
      @JsonKey(name: 'title') required this.text,
      required this.url,
      this.siteType});

  factory _$MainItemDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MainItemDataImplFromJson(json);

  @override
  @JsonKey(name: 'no')
  final int orderBy;
  @override
  final String board;
  @override
  final int type;
  @override
  @JsonKey(name: 'title')
  final String text;
  @override
  final String url;
  @override
  final SiteType? siteType;

  @override
  String toString() {
    return 'MainItemModel(orderBy: $orderBy, board: $board, type: $type, text: $text, url: $url, siteType: $siteType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainItemDataImpl &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderBy, board, type, text, url, siteType);

  /// Create a copy of MainItemModel
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

abstract class _MainItemData implements MainItemModel {
  const factory _MainItemData(
      {@JsonKey(name: 'no') required final int orderBy,
      required final String board,
      required final int type,
      @JsonKey(name: 'title') required final String text,
      required final String url,
      final SiteType? siteType}) = _$MainItemDataImpl;

  factory _MainItemData.fromJson(Map<String, dynamic> json) =
      _$MainItemDataImpl.fromJson;

  @override
  @JsonKey(name: 'no')
  int get orderBy;
  @override
  String get board;
  @override
  int get type;
  @override
  @JsonKey(name: 'title')
  String get text;
  @override
  String get url;
  @override
  SiteType? get siteType;

  /// Create a copy of MainItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MainItemDataImplCopyWith<_$MainItemDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
