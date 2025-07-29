// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_main_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MainItem {

 SiteType get siteType; String get board; String get text; String get url; int get orderBy; int get type; bool get hasItem; String get icon;
/// Create a copy of MainItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainItemCopyWith<MainItem> get copyWith => _$MainItemCopyWithImpl<MainItem>(this as MainItem, _$identity);

  /// Serializes this MainItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainItem&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.board, board) || other.board == board)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.orderBy, orderBy) || other.orderBy == orderBy)&&(identical(other.type, type) || other.type == type)&&(identical(other.hasItem, hasItem) || other.hasItem == hasItem)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteType,board,text,url,orderBy,type,hasItem,icon);

@override
String toString() {
  return 'MainItem(siteType: $siteType, board: $board, text: $text, url: $url, orderBy: $orderBy, type: $type, hasItem: $hasItem, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $MainItemCopyWith<$Res>  {
  factory $MainItemCopyWith(MainItem value, $Res Function(MainItem) _then) = _$MainItemCopyWithImpl;
@useResult
$Res call({
 SiteType siteType, String board, String text, String url, int orderBy, int type, bool hasItem, String icon
});




}
/// @nodoc
class _$MainItemCopyWithImpl<$Res>
    implements $MainItemCopyWith<$Res> {
  _$MainItemCopyWithImpl(this._self, this._then);

  final MainItem _self;
  final $Res Function(MainItem) _then;

/// Create a copy of MainItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? siteType = null,Object? board = null,Object? text = null,Object? url = null,Object? orderBy = null,Object? type = null,Object? hasItem = null,Object? icon = null,}) {
  return _then(_self.copyWith(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,orderBy: null == orderBy ? _self.orderBy : orderBy // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,hasItem: null == hasItem ? _self.hasItem : hasItem // ignore: cast_nullable_to_non_nullable
as bool,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MainItem].
extension MainItemPatterns on MainItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MainItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MainItem value)  $default,){
final _that = this;
switch (_that) {
case _MainItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MainItem value)?  $default,){
final _that = this;
switch (_that) {
case _MainItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SiteType siteType,  String board,  String text,  String url,  int orderBy,  int type,  bool hasItem,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainItem() when $default != null:
return $default(_that.siteType,_that.board,_that.text,_that.url,_that.orderBy,_that.type,_that.hasItem,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SiteType siteType,  String board,  String text,  String url,  int orderBy,  int type,  bool hasItem,  String icon)  $default,) {final _that = this;
switch (_that) {
case _MainItem():
return $default(_that.siteType,_that.board,_that.text,_that.url,_that.orderBy,_that.type,_that.hasItem,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SiteType siteType,  String board,  String text,  String url,  int orderBy,  int type,  bool hasItem,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _MainItem() when $default != null:
return $default(_that.siteType,_that.board,_that.text,_that.url,_that.orderBy,_that.type,_that.hasItem,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MainItem implements MainItem {
  const _MainItem({required this.siteType, required this.board, required this.text, required this.url, required this.orderBy, this.type = 0, this.hasItem = false, this.icon = ''});
  factory _MainItem.fromJson(Map<String, dynamic> json) => _$MainItemFromJson(json);

@override final  SiteType siteType;
@override final  String board;
@override final  String text;
@override final  String url;
@override final  int orderBy;
@override@JsonKey() final  int type;
@override@JsonKey() final  bool hasItem;
@override@JsonKey() final  String icon;

/// Create a copy of MainItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainItemCopyWith<_MainItem> get copyWith => __$MainItemCopyWithImpl<_MainItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MainItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainItem&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.board, board) || other.board == board)&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url)&&(identical(other.orderBy, orderBy) || other.orderBy == orderBy)&&(identical(other.type, type) || other.type == type)&&(identical(other.hasItem, hasItem) || other.hasItem == hasItem)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteType,board,text,url,orderBy,type,hasItem,icon);

@override
String toString() {
  return 'MainItem(siteType: $siteType, board: $board, text: $text, url: $url, orderBy: $orderBy, type: $type, hasItem: $hasItem, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$MainItemCopyWith<$Res> implements $MainItemCopyWith<$Res> {
  factory _$MainItemCopyWith(_MainItem value, $Res Function(_MainItem) _then) = __$MainItemCopyWithImpl;
@override @useResult
$Res call({
 SiteType siteType, String board, String text, String url, int orderBy, int type, bool hasItem, String icon
});




}
/// @nodoc
class __$MainItemCopyWithImpl<$Res>
    implements _$MainItemCopyWith<$Res> {
  __$MainItemCopyWithImpl(this._self, this._then);

  final _MainItem _self;
  final $Res Function(_MainItem) _then;

/// Create a copy of MainItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteType = null,Object? board = null,Object? text = null,Object? url = null,Object? orderBy = null,Object? type = null,Object? hasItem = null,Object? icon = null,}) {
  return _then(_MainItem(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,orderBy: null == orderBy ? _self.orderBy : orderBy // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,hasItem: null == hasItem ? _self.hasItem : hasItem // ignore: cast_nullable_to_non_nullable
as bool,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
