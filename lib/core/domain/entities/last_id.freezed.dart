// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'last_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LastId {

 dynamic get extra; int get intId; String get stringId;
/// Create a copy of LastId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastIdCopyWith<LastId> get copyWith => _$LastIdCopyWithImpl<LastId>(this as LastId, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastId&&const DeepCollectionEquality().equals(other.extra, extra)&&(identical(other.intId, intId) || other.intId == intId)&&(identical(other.stringId, stringId) || other.stringId == stringId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(extra),intId,stringId);

@override
String toString() {
  return 'LastId(extra: $extra, intId: $intId, stringId: $stringId)';
}


}

/// @nodoc
abstract mixin class $LastIdCopyWith<$Res>  {
  factory $LastIdCopyWith(LastId value, $Res Function(LastId) _then) = _$LastIdCopyWithImpl;
@useResult
$Res call({
 dynamic extra, int intId, String stringId
});




}
/// @nodoc
class _$LastIdCopyWithImpl<$Res>
    implements $LastIdCopyWith<$Res> {
  _$LastIdCopyWithImpl(this._self, this._then);

  final LastId _self;
  final $Res Function(LastId) _then;

/// Create a copy of LastId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? extra = freezed,Object? intId = null,Object? stringId = null,}) {
  return _then(_self.copyWith(
extra: freezed == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as dynamic,intId: null == intId ? _self.intId : intId // ignore: cast_nullable_to_non_nullable
as int,stringId: null == stringId ? _self.stringId : stringId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LastId].
extension LastIdPatterns on LastId {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastId value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastId() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastId value)  $default,){
final _that = this;
switch (_that) {
case _LastId():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastId value)?  $default,){
final _that = this;
switch (_that) {
case _LastId() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( dynamic extra,  int intId,  String stringId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastId() when $default != null:
return $default(_that.extra,_that.intId,_that.stringId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( dynamic extra,  int intId,  String stringId)  $default,) {final _that = this;
switch (_that) {
case _LastId():
return $default(_that.extra,_that.intId,_that.stringId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( dynamic extra,  int intId,  String stringId)?  $default,) {final _that = this;
switch (_that) {
case _LastId() when $default != null:
return $default(_that.extra,_that.intId,_that.stringId);case _:
  return null;

}
}

}

/// @nodoc


class _LastId implements LastId {
  const _LastId({this.extra, this.intId = -1, this.stringId = ''});
  

@override final  dynamic extra;
@override@JsonKey() final  int intId;
@override@JsonKey() final  String stringId;

/// Create a copy of LastId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastIdCopyWith<_LastId> get copyWith => __$LastIdCopyWithImpl<_LastId>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastId&&const DeepCollectionEquality().equals(other.extra, extra)&&(identical(other.intId, intId) || other.intId == intId)&&(identical(other.stringId, stringId) || other.stringId == stringId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(extra),intId,stringId);

@override
String toString() {
  return 'LastId(extra: $extra, intId: $intId, stringId: $stringId)';
}


}

/// @nodoc
abstract mixin class _$LastIdCopyWith<$Res> implements $LastIdCopyWith<$Res> {
  factory _$LastIdCopyWith(_LastId value, $Res Function(_LastId) _then) = __$LastIdCopyWithImpl;
@override @useResult
$Res call({
 dynamic extra, int intId, String stringId
});




}
/// @nodoc
class __$LastIdCopyWithImpl<$Res>
    implements _$LastIdCopyWith<$Res> {
  __$LastIdCopyWithImpl(this._self, this._then);

  final _LastId _self;
  final $Res Function(_LastId) _then;

/// Create a copy of LastId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? extra = freezed,Object? intId = null,Object? stringId = null,}) {
  return _then(_LastId(
extra: freezed == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as dynamic,intId: null == intId ? _self.intId : intId // ignore: cast_nullable_to_non_nullable
as int,stringId: null == stringId ? _self.stringId : stringId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
