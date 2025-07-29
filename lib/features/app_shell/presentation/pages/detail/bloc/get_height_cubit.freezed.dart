// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_height_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetHeightState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetHeightState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetHeightState()';
}


}

/// @nodoc
class $GetHeightStateCopyWith<$Res>  {
$GetHeightStateCopyWith(GetHeightState _, $Res Function(GetHeightState) __);
}


/// Adds pattern-matching-related methods to [GetHeightState].
extension GetHeightStatePatterns on GetHeightState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitialGetHeightState value)?  initial,TResult Function( SuccessGetHeightState value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitialGetHeightState() when initial != null:
return initial(_that);case SuccessGetHeightState() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitialGetHeightState value)  initial,required TResult Function( SuccessGetHeightState value)  success,}){
final _that = this;
switch (_that) {
case InitialGetHeightState():
return initial(_that);case SuccessGetHeightState():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitialGetHeightState value)?  initial,TResult? Function( SuccessGetHeightState value)?  success,}){
final _that = this;
switch (_that) {
case InitialGetHeightState() when initial != null:
return initial(_that);case SuccessGetHeightState() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( double height)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitialGetHeightState() when initial != null:
return initial();case SuccessGetHeightState() when success != null:
return success(_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( double height)  success,}) {final _that = this;
switch (_that) {
case InitialGetHeightState():
return initial();case SuccessGetHeightState():
return success(_that.height);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( double height)?  success,}) {final _that = this;
switch (_that) {
case InitialGetHeightState() when initial != null:
return initial();case SuccessGetHeightState() when success != null:
return success(_that.height);case _:
  return null;

}
}

}

/// @nodoc


class InitialGetHeightState implements GetHeightState {
  const InitialGetHeightState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialGetHeightState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetHeightState.initial()';
}


}




/// @nodoc


class SuccessGetHeightState implements GetHeightState {
  const SuccessGetHeightState(this.height);
  

 final  double height;

/// Create a copy of GetHeightState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessGetHeightStateCopyWith<SuccessGetHeightState> get copyWith => _$SuccessGetHeightStateCopyWithImpl<SuccessGetHeightState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessGetHeightState&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,height);

@override
String toString() {
  return 'GetHeightState.success(height: $height)';
}


}

/// @nodoc
abstract mixin class $SuccessGetHeightStateCopyWith<$Res> implements $GetHeightStateCopyWith<$Res> {
  factory $SuccessGetHeightStateCopyWith(SuccessGetHeightState value, $Res Function(SuccessGetHeightState) _then) = _$SuccessGetHeightStateCopyWithImpl;
@useResult
$Res call({
 double height
});




}
/// @nodoc
class _$SuccessGetHeightStateCopyWithImpl<$Res>
    implements $SuccessGetHeightStateCopyWith<$Res> {
  _$SuccessGetHeightStateCopyWithImpl(this._self, this._then);

  final SuccessGetHeightState _self;
  final $Res Function(SuccessGetHeightState) _then;

/// Create a copy of GetHeightState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? height = null,}) {
  return _then(SuccessGetHeightState(
null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
