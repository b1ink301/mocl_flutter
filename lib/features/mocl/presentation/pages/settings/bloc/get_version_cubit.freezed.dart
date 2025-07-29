// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_version_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetVersionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetVersionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetVersionState()';
}


}

/// @nodoc
class $GetVersionStateCopyWith<$Res>  {
$GetVersionStateCopyWith(GetVersionState _, $Res Function(GetVersionState) __);
}


/// Adds pattern-matching-related methods to [GetVersionState].
extension GetVersionStatePatterns on GetVersionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitialGetVersionState value)?  initial,TResult Function( LoadingGetVersionState value)?  loading,TResult Function( SuccessGetVersionState value)?  success,TResult Function( FailureGetVersionState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitialGetVersionState() when initial != null:
return initial(_that);case LoadingGetVersionState() when loading != null:
return loading(_that);case SuccessGetVersionState() when success != null:
return success(_that);case FailureGetVersionState() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitialGetVersionState value)  initial,required TResult Function( LoadingGetVersionState value)  loading,required TResult Function( SuccessGetVersionState value)  success,required TResult Function( FailureGetVersionState value)  failure,}){
final _that = this;
switch (_that) {
case InitialGetVersionState():
return initial(_that);case LoadingGetVersionState():
return loading(_that);case SuccessGetVersionState():
return success(_that);case FailureGetVersionState():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitialGetVersionState value)?  initial,TResult? Function( LoadingGetVersionState value)?  loading,TResult? Function( SuccessGetVersionState value)?  success,TResult? Function( FailureGetVersionState value)?  failure,}){
final _that = this;
switch (_that) {
case InitialGetVersionState() when initial != null:
return initial(_that);case LoadingGetVersionState() when loading != null:
return loading(_that);case SuccessGetVersionState() when success != null:
return success(_that);case FailureGetVersionState() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String version)?  success,TResult Function( String errorMessage)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitialGetVersionState() when initial != null:
return initial();case LoadingGetVersionState() when loading != null:
return loading();case SuccessGetVersionState() when success != null:
return success(_that.version);case FailureGetVersionState() when failure != null:
return failure(_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String version)  success,required TResult Function( String errorMessage)  failure,}) {final _that = this;
switch (_that) {
case InitialGetVersionState():
return initial();case LoadingGetVersionState():
return loading();case SuccessGetVersionState():
return success(_that.version);case FailureGetVersionState():
return failure(_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String version)?  success,TResult? Function( String errorMessage)?  failure,}) {final _that = this;
switch (_that) {
case InitialGetVersionState() when initial != null:
return initial();case LoadingGetVersionState() when loading != null:
return loading();case SuccessGetVersionState() when success != null:
return success(_that.version);case FailureGetVersionState() when failure != null:
return failure(_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class InitialGetVersionState implements GetVersionState {
  const InitialGetVersionState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialGetVersionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetVersionState.initial()';
}


}




/// @nodoc


class LoadingGetVersionState implements GetVersionState {
  const LoadingGetVersionState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadingGetVersionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetVersionState.loading()';
}


}




/// @nodoc


class SuccessGetVersionState implements GetVersionState {
  const SuccessGetVersionState(this.version);
  

 final  String version;

/// Create a copy of GetVersionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessGetVersionStateCopyWith<SuccessGetVersionState> get copyWith => _$SuccessGetVersionStateCopyWithImpl<SuccessGetVersionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessGetVersionState&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,version);

@override
String toString() {
  return 'GetVersionState.success(version: $version)';
}


}

/// @nodoc
abstract mixin class $SuccessGetVersionStateCopyWith<$Res> implements $GetVersionStateCopyWith<$Res> {
  factory $SuccessGetVersionStateCopyWith(SuccessGetVersionState value, $Res Function(SuccessGetVersionState) _then) = _$SuccessGetVersionStateCopyWithImpl;
@useResult
$Res call({
 String version
});




}
/// @nodoc
class _$SuccessGetVersionStateCopyWithImpl<$Res>
    implements $SuccessGetVersionStateCopyWith<$Res> {
  _$SuccessGetVersionStateCopyWithImpl(this._self, this._then);

  final SuccessGetVersionState _self;
  final $Res Function(SuccessGetVersionState) _then;

/// Create a copy of GetVersionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? version = null,}) {
  return _then(SuccessGetVersionState(
null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FailureGetVersionState implements GetVersionState {
  const FailureGetVersionState(this.errorMessage);
  

 final  String errorMessage;

/// Create a copy of GetVersionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureGetVersionStateCopyWith<FailureGetVersionState> get copyWith => _$FailureGetVersionStateCopyWithImpl<FailureGetVersionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FailureGetVersionState&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,errorMessage);

@override
String toString() {
  return 'GetVersionState.failure(errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FailureGetVersionStateCopyWith<$Res> implements $GetVersionStateCopyWith<$Res> {
  factory $FailureGetVersionStateCopyWith(FailureGetVersionState value, $Res Function(FailureGetVersionState) _then) = _$FailureGetVersionStateCopyWithImpl;
@useResult
$Res call({
 String errorMessage
});




}
/// @nodoc
class _$FailureGetVersionStateCopyWithImpl<$Res>
    implements $FailureGetVersionStateCopyWith<$Res> {
  _$FailureGetVersionStateCopyWithImpl(this._self, this._then);

  final FailureGetVersionState _self;
  final $Res Function(FailureGetVersionState) _then;

/// Create a copy of GetVersionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMessage = null,}) {
  return _then(FailureGetVersionState(
null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
