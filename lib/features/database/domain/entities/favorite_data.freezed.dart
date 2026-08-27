// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteData {

 SiteType get siteType; String get board; String get text; String get url; int get type; String get icon; int get savedAt;
/// Create a copy of FavoriteData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteDataCopyWith<FavoriteData> get copyWith => _$FavoriteDataCopyWithImpl<FavoriteData>(this as FavoriteData, _$identity);

  /// Serializes this FavoriteData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteData&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.board, board) || other.board == board)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteType,board,text,url,type,icon,savedAt);

@override
String toString() {
  return 'FavoriteData(siteType: $siteType, board: $board, text: $text, url: $url, type: $type, icon: $icon, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteDataCopyWith<$Res>  {
  factory $FavoriteDataCopyWith(FavoriteData value, $Res Function(FavoriteData) _then) = _$FavoriteDataCopyWithImpl;
@useResult
$Res call({
 SiteType siteType, String board, String text, String url, int type, String icon, int savedAt
});




}
/// @nodoc
class _$FavoriteDataCopyWithImpl<$Res>
    implements $FavoriteDataCopyWith<$Res> {
  _$FavoriteDataCopyWithImpl(this._self, this._then);

  final FavoriteData _self;
  final $Res Function(FavoriteData) _then;

/// Create a copy of FavoriteData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? siteType = null,Object? board = null,Object? text = null,Object? url = null,Object? type = null,Object? icon = null,Object? savedAt = null,}) {
  return _then(FavoriteData(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteData].
extension FavoriteDataPatterns on FavoriteData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteData value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteData value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SiteType siteType,  String board,  String text,  String url,  int type,  String icon,  int savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteData() when $default != null:
return $default(_that.siteType,_that.board,_that.text,_that.url,_that.type,_that.icon,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SiteType siteType,  String board,  String text,  String url,  int type,  String icon,  int savedAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteData():
return $default(_that.siteType,_that.board,_that.text,_that.url,_that.type,_that.icon,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SiteType siteType,  String board,  String text,  String url,  int type,  String icon,  int savedAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteData() when $default != null:
return $default(_that.siteType,_that.board,_that.text,_that.url,_that.type,_that.icon,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteData extends FavoriteData {
  const _FavoriteData({required this.siteType, required this.board, required this.text, required this.url, required this.type, required this.icon, required this.savedAt}): super._();
  factory _FavoriteData.fromJson(Map<String, dynamic> json) => _$FavoriteDataFromJson(json);

@override final  SiteType siteType;
@override final  String board;
@override final  String text;
@override final  String url;
@override final  int type;
@override final  String icon;
@override final  int savedAt;

/// Create a copy of FavoriteData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteDataCopyWith<_FavoriteData> get copyWith => __$FavoriteDataCopyWithImpl<_FavoriteData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteData&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.board, board) || other.board == board)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteType,board,text,url,type,icon,savedAt);

@override
String toString() {
  return 'FavoriteData(siteType: $siteType, board: $board, text: $text, url: $url, type: $type, icon: $icon, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteDataCopyWith<$Res> implements $FavoriteDataCopyWith<$Res> {
  factory _$FavoriteDataCopyWith(_FavoriteData value, $Res Function(_FavoriteData) _then) = __$FavoriteDataCopyWithImpl;
@override @useResult
$Res call({
 SiteType siteType, String board, String text, String url, int type, String icon, int savedAt
});




}
/// @nodoc
class __$FavoriteDataCopyWithImpl<$Res>
    implements _$FavoriteDataCopyWith<$Res> {
  __$FavoriteDataCopyWithImpl(this._self, this._then);

  final _FavoriteData _self;
  final $Res Function(_FavoriteData) _then;

/// Create a copy of FavoriteData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteType = null,Object? board = null,Object? text = null,Object? url = null,Object? type = null,Object? icon = null,Object? savedAt = null,}) {
  return _then(_FavoriteData(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
