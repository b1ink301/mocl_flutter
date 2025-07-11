// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
MainItemModel _$MainItemModelFromJson(
  Map<String, dynamic> json
) {
    return _MainItemData.fromJson(
      json
    );
}

/// @nodoc
mixin _$MainItemModel {

@JsonKey(name: 'no') int get orderBy; String get board; int get type;@JsonKey(name: 'title') String get text; String get url; SiteType? get siteType;
/// Create a copy of MainItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainItemModelCopyWith<MainItemModel> get copyWith => _$MainItemModelCopyWithImpl<MainItemModel>(this as MainItemModel, _$identity);

  /// Serializes this MainItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainItemModel&&(identical(other.orderBy, orderBy) || other.orderBy == orderBy)&&(identical(other.board, board) || other.board == board)&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.siteType, siteType) || other.siteType == siteType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderBy,board,type,text,url,siteType);

@override
String toString() {
  return 'MainItemModel(orderBy: $orderBy, board: $board, type: $type, text: $text, url: $url, siteType: $siteType)';
}


}

/// @nodoc
abstract mixin class $MainItemModelCopyWith<$Res>  {
  factory $MainItemModelCopyWith(MainItemModel value, $Res Function(MainItemModel) _then) = _$MainItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'no') int orderBy, String board, int type,@JsonKey(name: 'title') String text, String url, SiteType? siteType
});




}
/// @nodoc
class _$MainItemModelCopyWithImpl<$Res>
    implements $MainItemModelCopyWith<$Res> {
  _$MainItemModelCopyWithImpl(this._self, this._then);

  final MainItemModel _self;
  final $Res Function(MainItemModel) _then;

/// Create a copy of MainItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderBy = null,Object? board = null,Object? type = null,Object? text = null,Object? url = null,Object? siteType = freezed,}) {
  return _then(_self.copyWith(
orderBy: null == orderBy ? _self.orderBy : orderBy // ignore: cast_nullable_to_non_nullable
as int,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,siteType: freezed == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType?,
  ));
}

}


/// Adds pattern-matching-related methods to [MainItemModel].
extension MainItemModelPatterns on MainItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MainItemData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainItemData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MainItemData value)  $default,){
final _that = this;
switch (_that) {
case _MainItemData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MainItemData value)?  $default,){
final _that = this;
switch (_that) {
case _MainItemData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'no')  int orderBy,  String board,  int type, @JsonKey(name: 'title')  String text,  String url,  SiteType? siteType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainItemData() when $default != null:
return $default(_that.orderBy,_that.board,_that.type,_that.text,_that.url,_that.siteType);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'no')  int orderBy,  String board,  int type, @JsonKey(name: 'title')  String text,  String url,  SiteType? siteType)  $default,) {final _that = this;
switch (_that) {
case _MainItemData():
return $default(_that.orderBy,_that.board,_that.type,_that.text,_that.url,_that.siteType);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'no')  int orderBy,  String board,  int type, @JsonKey(name: 'title')  String text,  String url,  SiteType? siteType)?  $default,) {final _that = this;
switch (_that) {
case _MainItemData() when $default != null:
return $default(_that.orderBy,_that.board,_that.type,_that.text,_that.url,_that.siteType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MainItemData implements MainItemModel {
  const _MainItemData({@JsonKey(name: 'no') required this.orderBy, required this.board, required this.type, @JsonKey(name: 'title') required this.text, required this.url, this.siteType});
  factory _MainItemData.fromJson(Map<String, dynamic> json) => _$MainItemDataFromJson(json);

@override@JsonKey(name: 'no') final  int orderBy;
@override final  String board;
@override final  int type;
@override@JsonKey(name: 'title') final  String text;
@override final  String url;
@override final  SiteType? siteType;

/// Create a copy of MainItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainItemDataCopyWith<_MainItemData> get copyWith => __$MainItemDataCopyWithImpl<_MainItemData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MainItemDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainItemData&&(identical(other.orderBy, orderBy) || other.orderBy == orderBy)&&(identical(other.board, board) || other.board == board)&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.siteType, siteType) || other.siteType == siteType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderBy,board,type,text,url,siteType);

@override
String toString() {
  return 'MainItemModel(orderBy: $orderBy, board: $board, type: $type, text: $text, url: $url, siteType: $siteType)';
}


}

/// @nodoc
abstract mixin class _$MainItemDataCopyWith<$Res> implements $MainItemModelCopyWith<$Res> {
  factory _$MainItemDataCopyWith(_MainItemData value, $Res Function(_MainItemData) _then) = __$MainItemDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'no') int orderBy, String board, int type,@JsonKey(name: 'title') String text, String url, SiteType? siteType
});




}
/// @nodoc
class __$MainItemDataCopyWithImpl<$Res>
    implements _$MainItemDataCopyWith<$Res> {
  __$MainItemDataCopyWithImpl(this._self, this._then);

  final _MainItemData _self;
  final $Res Function(_MainItemData) _then;

/// Create a copy of MainItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderBy = null,Object? board = null,Object? type = null,Object? text = null,Object? url = null,Object? siteType = freezed,}) {
  return _then(_MainItemData(
orderBy: null == orderBy ? _self.orderBy : orderBy // ignore: cast_nullable_to_non_nullable
as int,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,siteType: freezed == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType?,
  ));
}


}

// dart format on
