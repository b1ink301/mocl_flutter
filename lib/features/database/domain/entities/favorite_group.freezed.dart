// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteGroup {

 String get id; String get name; int get orderBy;
/// Create a copy of FavoriteGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteGroupCopyWith<FavoriteGroup> get copyWith => _$FavoriteGroupCopyWithImpl<FavoriteGroup>(this as FavoriteGroup, _$identity);

  /// Serializes this FavoriteGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FavoriteGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteGroup&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.orderBy, _this.orderBy) || other.orderBy == _this.orderBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FavoriteGroup;
  return Object.hash(runtimeType,_this.id,_this.name,_this.orderBy);
}

@override
String toString() {
  final _this = this as FavoriteGroup;
  return 'FavoriteGroup(id: ${_this.id}, name: ${_this.name}, orderBy: ${_this.orderBy})';
}


}

/// @nodoc
abstract mixin class $FavoriteGroupCopyWith<$Res>  {
  factory $FavoriteGroupCopyWith(FavoriteGroup value, $Res Function(FavoriteGroup) _then) = _$FavoriteGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, int orderBy
});




}
/// @nodoc
class _$FavoriteGroupCopyWithImpl<$Res>
    implements $FavoriteGroupCopyWith<$Res> {
  _$FavoriteGroupCopyWithImpl(this._self, this._then);

  final FavoriteGroup _self;
  final $Res Function(FavoriteGroup) _then;

/// Create a copy of FavoriteGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? orderBy = null,}) {
  return _then(FavoriteGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orderBy: null == orderBy ? _self.orderBy : orderBy // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteGroup].
extension FavoriteGroupPatterns on FavoriteGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteGroup value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteGroup value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int orderBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteGroup() when $default != null:
return $default(_that.id,_that.name,_that.orderBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int orderBy)  $default,) {final _that = this;
switch (_that) {
case _FavoriteGroup():
return $default(_that.id,_that.name,_that.orderBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int orderBy)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteGroup() when $default != null:
return $default(_that.id,_that.name,_that.orderBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteGroup implements FavoriteGroup {
  const _FavoriteGroup({required this.id, required this.name, required this.orderBy});
  factory _FavoriteGroup.fromJson(Map<String, dynamic> json) => _$FavoriteGroupFromJson(json);

@override final  String id;
@override final  String name;
@override final  int orderBy;

/// Create a copy of FavoriteGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteGroupCopyWith<_FavoriteGroup> get copyWith => __$FavoriteGroupCopyWithImpl<_FavoriteGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteGroupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.orderBy, orderBy) || other.orderBy == orderBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,orderBy);
}

@override
String toString() {
    return 'FavoriteGroup(id: $id, name: $name, orderBy: $orderBy)';
}


}

/// @nodoc
abstract mixin class _$FavoriteGroupCopyWith<$Res> implements $FavoriteGroupCopyWith<$Res> {
  factory _$FavoriteGroupCopyWith(_FavoriteGroup value, $Res Function(_FavoriteGroup) _then) = __$FavoriteGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int orderBy
});




}
/// @nodoc
class __$FavoriteGroupCopyWithImpl<$Res>
    implements _$FavoriteGroupCopyWith<$Res> {
  __$FavoriteGroupCopyWithImpl(this._self, this._then);

  final _FavoriteGroup _self;
  final $Res Function(_FavoriteGroup) _then;

/// Create a copy of FavoriteGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? orderBy = null,}) {
  return _then(_FavoriteGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orderBy: null == orderBy ? _self.orderBy : orderBy // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
