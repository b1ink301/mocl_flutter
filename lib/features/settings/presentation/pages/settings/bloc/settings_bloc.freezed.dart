// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsEvent'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsEvent()';
}


}

/// @nodoc
class $SettingsEventCopyWith<$Res>  {
$SettingsEventCopyWith(SettingsEvent _, $Res Function(SettingsEvent) __);
}


/// Adds pattern-matching-related methods to [SettingsEvent].
extension SettingsEventPatterns on SettingsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GetVersionEvent value)?  getVersion,TResult Function( ClearDataEvent value)?  clearData,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GetVersionEvent() when getVersion != null:
return getVersion(_that);case ClearDataEvent() when clearData != null:
return clearData(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GetVersionEvent value)  getVersion,required TResult Function( ClearDataEvent value)  clearData,}){
final _that = this;
switch (_that) {
case GetVersionEvent():
return getVersion(_that);case ClearDataEvent():
return clearData(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GetVersionEvent value)?  getVersion,TResult? Function( ClearDataEvent value)?  clearData,}){
final _that = this;
switch (_that) {
case GetVersionEvent() when getVersion != null:
return getVersion(_that);case ClearDataEvent() when clearData != null:
return clearData(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  getVersion,TResult Function()?  clearData,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GetVersionEvent() when getVersion != null:
return getVersion();case ClearDataEvent() when clearData != null:
return clearData();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  getVersion,required TResult Function()  clearData,}) {final _that = this;
switch (_that) {
case GetVersionEvent():
return getVersion();case ClearDataEvent():
return clearData();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  getVersion,TResult? Function()?  clearData,}) {final _that = this;
switch (_that) {
case GetVersionEvent() when getVersion != null:
return getVersion();case ClearDataEvent() when clearData != null:
return clearData();case _:
  return null;

}
}

}

/// @nodoc


class GetVersionEvent with DiagnosticableTreeMixin implements SettingsEvent {
  const GetVersionEvent();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsEvent.getVersion'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetVersionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsEvent.getVersion()';
}


}




/// @nodoc


class ClearDataEvent with DiagnosticableTreeMixin implements SettingsEvent {
  const ClearDataEvent();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsEvent.clearData'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearDataEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsEvent.clearData()';
}


}




/// @nodoc
mixin _$SettingsState<T> implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsState<$T>'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsState<$T>()';
}


}

/// @nodoc
class $SettingsStateCopyWith<T,$Res>  {
$SettingsStateCopyWith(SettingsState<T> _, $Res Function(SettingsState<T>) __);
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns<T> on SettingsState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StateInitial<T> value)?  initial,TResult Function( StateLoading<T> value)?  loading,TResult Function( StateSuccess<T> value)?  success,TResult Function( StateFailure<T> value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StateInitial() when initial != null:
return initial(_that);case StateLoading() when loading != null:
return loading(_that);case StateSuccess() when success != null:
return success(_that);case StateFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StateInitial<T> value)  initial,required TResult Function( StateLoading<T> value)  loading,required TResult Function( StateSuccess<T> value)  success,required TResult Function( StateFailure<T> value)  failure,}){
final _that = this;
switch (_that) {
case StateInitial():
return initial(_that);case StateLoading():
return loading(_that);case StateSuccess():
return success(_that);case StateFailure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StateInitial<T> value)?  initial,TResult? Function( StateLoading<T> value)?  loading,TResult? Function( StateSuccess<T> value)?  success,TResult? Function( StateFailure<T> value)?  failure,}){
final _that = this;
switch (_that) {
case StateInitial() when initial != null:
return initial(_that);case StateLoading() when loading != null:
return loading(_that);case StateSuccess() when success != null:
return success(_that);case StateFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( T data)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StateInitial() when initial != null:
return initial();case StateLoading() when loading != null:
return loading();case StateSuccess() when success != null:
return success(_that.data);case StateFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( T data)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case StateInitial():
return initial();case StateLoading():
return loading();case StateSuccess():
return success(_that.data);case StateFailure():
return failure(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( T data)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case StateInitial() when initial != null:
return initial();case StateLoading() when loading != null:
return loading();case StateSuccess() when success != null:
return success(_that.data);case StateFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class StateInitial<T> with DiagnosticableTreeMixin implements SettingsState<T> {
  const StateInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsState<$T>.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StateInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsState<$T>.initial()';
}


}




/// @nodoc


class StateLoading<T> with DiagnosticableTreeMixin implements SettingsState<T> {
  const StateLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsState<$T>.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StateLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsState<$T>.loading()';
}


}




/// @nodoc


class StateSuccess<T> with DiagnosticableTreeMixin implements SettingsState<T> {
  const StateSuccess(this.data);
  

 final  T data;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StateSuccessCopyWith<T, StateSuccess<T>> get copyWith => _$StateSuccessCopyWithImpl<T, StateSuccess<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsState<$T>.success'))
    ..add(DiagnosticsProperty('data', data));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StateSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsState<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $StateSuccessCopyWith<T,$Res> implements $SettingsStateCopyWith<T, $Res> {
  factory $StateSuccessCopyWith(StateSuccess<T> value, $Res Function(StateSuccess<T>) _then) = _$StateSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$StateSuccessCopyWithImpl<T,$Res>
    implements $StateSuccessCopyWith<T, $Res> {
  _$StateSuccessCopyWithImpl(this._self, this._then);

  final StateSuccess<T> _self;
  final $Res Function(StateSuccess<T>) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(StateSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class StateFailure<T> with DiagnosticableTreeMixin implements SettingsState<T> {
  const StateFailure(this.message);
  

 final  String message;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StateFailureCopyWith<T, StateFailure<T>> get copyWith => _$StateFailureCopyWithImpl<T, StateFailure<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SettingsState<$T>.failure'))
    ..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StateFailure<T>&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SettingsState<$T>.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $StateFailureCopyWith<T,$Res> implements $SettingsStateCopyWith<T, $Res> {
  factory $StateFailureCopyWith(StateFailure<T> value, $Res Function(StateFailure<T>) _then) = _$StateFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$StateFailureCopyWithImpl<T,$Res>
    implements $StateFailureCopyWith<T, $Res> {
  _$StateFailureCopyWithImpl(this._self, this._then);

  final StateFailure<T> _self;
  final $Res Function(StateFailure<T>) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(StateFailure<T>(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
