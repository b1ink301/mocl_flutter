// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mute_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MuteRule {

 String get pattern; MuteType get type; int get createdAt;
/// Create a copy of MuteRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MuteRuleCopyWith<MuteRule> get copyWith => _$MuteRuleCopyWithImpl<MuteRule>(this as MuteRule, _$identity);

  /// Serializes this MuteRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MuteRule&&(identical(other.pattern, pattern) || other.pattern == pattern)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pattern,type,createdAt);

@override
String toString() {
  return 'MuteRule(pattern: $pattern, type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MuteRuleCopyWith<$Res>  {
  factory $MuteRuleCopyWith(MuteRule value, $Res Function(MuteRule) _then) = _$MuteRuleCopyWithImpl;
@useResult
$Res call({
 String pattern, MuteType type, int createdAt
});




}
/// @nodoc
class _$MuteRuleCopyWithImpl<$Res>
    implements $MuteRuleCopyWith<$Res> {
  _$MuteRuleCopyWithImpl(this._self, this._then);

  final MuteRule _self;
  final $Res Function(MuteRule) _then;

/// Create a copy of MuteRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pattern = null,Object? type = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MuteType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MuteRule].
extension MuteRulePatterns on MuteRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MuteRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MuteRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MuteRule value)  $default,){
final _that = this;
switch (_that) {
case _MuteRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MuteRule value)?  $default,){
final _that = this;
switch (_that) {
case _MuteRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pattern,  MuteType type,  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MuteRule() when $default != null:
return $default(_that.pattern,_that.type,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pattern,  MuteType type,  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _MuteRule():
return $default(_that.pattern,_that.type,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pattern,  MuteType type,  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MuteRule() when $default != null:
return $default(_that.pattern,_that.type,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MuteRule implements MuteRule {
  const _MuteRule({required this.pattern, required this.type, required this.createdAt});
  factory _MuteRule.fromJson(Map<String, dynamic> json) => _$MuteRuleFromJson(json);

@override final  String pattern;
@override final  MuteType type;
@override final  int createdAt;

/// Create a copy of MuteRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MuteRuleCopyWith<_MuteRule> get copyWith => __$MuteRuleCopyWithImpl<_MuteRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MuteRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MuteRule&&(identical(other.pattern, pattern) || other.pattern == pattern)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pattern,type,createdAt);

@override
String toString() {
  return 'MuteRule(pattern: $pattern, type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MuteRuleCopyWith<$Res> implements $MuteRuleCopyWith<$Res> {
  factory _$MuteRuleCopyWith(_MuteRule value, $Res Function(_MuteRule) _then) = __$MuteRuleCopyWithImpl;
@override @useResult
$Res call({
 String pattern, MuteType type, int createdAt
});




}
/// @nodoc
class __$MuteRuleCopyWithImpl<$Res>
    implements _$MuteRuleCopyWith<$Res> {
  __$MuteRuleCopyWithImpl(this._self, this._then);

  final _MuteRule _self;
  final $Res Function(_MuteRule) _then;

/// Create a copy of MuteRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pattern = null,Object? type = null,Object? createdAt = null,}) {
  return _then(_MuteRule(
pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MuteType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
