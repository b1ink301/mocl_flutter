// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clear_data_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClearDataState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearDataState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClearDataState()';
}


}

/// @nodoc
class $ClearDataStateCopyWith<$Res>  {
$ClearDataStateCopyWith(ClearDataState _, $Res Function(ClearDataState) __);
}


/// Adds pattern-matching-related methods to [ClearDataState].
extension ClearDataStatePatterns on ClearDataState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitialClearDataState value)?  initial,TResult Function( LoadingClearDataState value)?  loading,TResult Function( SuccessClearDataState value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitialClearDataState() when initial != null:
return initial(_that);case LoadingClearDataState() when loading != null:
return loading(_that);case SuccessClearDataState() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitialClearDataState value)  initial,required TResult Function( LoadingClearDataState value)  loading,required TResult Function( SuccessClearDataState value)  success,}){
final _that = this;
switch (_that) {
case InitialClearDataState():
return initial(_that);case LoadingClearDataState():
return loading(_that);case SuccessClearDataState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitialClearDataState value)?  initial,TResult? Function( LoadingClearDataState value)?  loading,TResult? Function( SuccessClearDataState value)?  success,}){
final _that = this;
switch (_that) {
case InitialClearDataState() when initial != null:
return initial(_that);case LoadingClearDataState() when loading != null:
return loading(_that);case SuccessClearDataState() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitialClearDataState() when initial != null:
return initial();case LoadingClearDataState() when loading != null:
return loading();case SuccessClearDataState() when success != null:
return success();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,}) {final _that = this;
switch (_that) {
case InitialClearDataState():
return initial();case LoadingClearDataState():
return loading();case SuccessClearDataState():
return success();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,}) {final _that = this;
switch (_that) {
case InitialClearDataState() when initial != null:
return initial();case LoadingClearDataState() when loading != null:
return loading();case SuccessClearDataState() when success != null:
return success();case _:
  return null;

}
}

}

/// @nodoc


class InitialClearDataState implements ClearDataState {
  const InitialClearDataState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialClearDataState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClearDataState.initial()';
}


}




/// @nodoc


class LoadingClearDataState implements ClearDataState {
  const LoadingClearDataState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadingClearDataState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClearDataState.loading()';
}


}




/// @nodoc


class SuccessClearDataState implements ClearDataState {
  const SuccessClearDataState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessClearDataState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClearDataState.success()';
}


}




// dart format on
