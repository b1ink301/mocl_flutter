// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_item_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MainItemData {

 String get board; String get text; String get url; SiteType get siteType; int get orderBy; int get type;
/// Create a copy of MainItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainItemDataCopyWith<MainItemData> get copyWith => _$MainItemDataCopyWithImpl<MainItemData>(this as MainItemData, _$identity);

  /// Serializes this MainItemData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainItemData&&(identical(other.board, board) || other.board == board)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.orderBy, orderBy) || other.orderBy == orderBy)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,board,text,url,siteType,orderBy,type);

@override
String toString() {
  return 'MainItemData(board: $board, text: $text, url: $url, siteType: $siteType, orderBy: $orderBy, type: $type)';
}


}

/// @nodoc
abstract mixin class $MainItemDataCopyWith<$Res>  {
  factory $MainItemDataCopyWith(MainItemData value, $Res Function(MainItemData) _then) = _$MainItemDataCopyWithImpl;
@useResult
$Res call({
 String board, String text, String url, SiteType siteType, int orderBy, int type
});




}
/// @nodoc
class _$MainItemDataCopyWithImpl<$Res>
    implements $MainItemDataCopyWith<$Res> {
  _$MainItemDataCopyWithImpl(this._self, this._then);

  final MainItemData _self;
  final $Res Function(MainItemData) _then;

/// Create a copy of MainItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? board = null,Object? text = null,Object? url = null,Object? siteType = null,Object? orderBy = null,Object? type = null,}) {
  return _then(_self.copyWith(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,orderBy: null == orderBy ? _self.orderBy : orderBy // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MainItemData].
extension MainItemDataPatterns on MainItemData {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String board,  String text,  String url,  SiteType siteType,  int orderBy,  int type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainItemData() when $default != null:
return $default(_that.board,_that.text,_that.url,_that.siteType,_that.orderBy,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String board,  String text,  String url,  SiteType siteType,  int orderBy,  int type)  $default,) {final _that = this;
switch (_that) {
case _MainItemData():
return $default(_that.board,_that.text,_that.url,_that.siteType,_that.orderBy,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String board,  String text,  String url,  SiteType siteType,  int orderBy,  int type)?  $default,) {final _that = this;
switch (_that) {
case _MainItemData() when $default != null:
return $default(_that.board,_that.text,_that.url,_that.siteType,_that.orderBy,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MainItemData implements MainItemData {
  const _MainItemData({required this.board, required this.text, required this.url, required this.siteType, required this.orderBy, required this.type});
  factory _MainItemData.fromJson(Map<String, dynamic> json) => _$MainItemDataFromJson(json);

@override final  String board;
@override final  String text;
@override final  String url;
@override final  SiteType siteType;
@override final  int orderBy;
@override final  int type;

/// Create a copy of MainItemData
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainItemData&&(identical(other.board, board) || other.board == board)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.orderBy, orderBy) || other.orderBy == orderBy)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,board,text,url,siteType,orderBy,type);

@override
String toString() {
  return 'MainItemData(board: $board, text: $text, url: $url, siteType: $siteType, orderBy: $orderBy, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MainItemDataCopyWith<$Res> implements $MainItemDataCopyWith<$Res> {
  factory _$MainItemDataCopyWith(_MainItemData value, $Res Function(_MainItemData) _then) = __$MainItemDataCopyWithImpl;
@override @useResult
$Res call({
 String board, String text, String url, SiteType siteType, int orderBy, int type
});




}
/// @nodoc
class __$MainItemDataCopyWithImpl<$Res>
    implements _$MainItemDataCopyWith<$Res> {
  __$MainItemDataCopyWithImpl(this._self, this._then);

  final _MainItemData _self;
  final $Res Function(_MainItemData) _then;

/// Create a copy of MainItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? text = null,Object? url = null,Object? siteType = null,Object? orderBy = null,Object? type = null,}) {
  return _then(_MainItemData(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,orderBy: null == orderBy ? _self.orderBy : orderBy // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
