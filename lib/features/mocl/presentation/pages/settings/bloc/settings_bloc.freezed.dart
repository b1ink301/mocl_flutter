// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getVersion,
    required TResult Function() clearData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getVersion,
    TResult? Function()? clearData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getVersion,
    TResult Function()? clearData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetVersionEvent value) getVersion,
    required TResult Function(ClearDataEvent value) clearData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetVersionEvent value)? getVersion,
    TResult? Function(ClearDataEvent value)? clearData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetVersionEvent value)? getVersion,
    TResult Function(ClearDataEvent value)? clearData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsEventCopyWith<$Res> {
  factory $SettingsEventCopyWith(
          SettingsEvent value, $Res Function(SettingsEvent) then) =
      _$SettingsEventCopyWithImpl<$Res, SettingsEvent>;
}

/// @nodoc
class _$SettingsEventCopyWithImpl<$Res, $Val extends SettingsEvent>
    implements $SettingsEventCopyWith<$Res> {
  _$SettingsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetVersionEventImplCopyWith<$Res> {
  factory _$$GetVersionEventImplCopyWith(_$GetVersionEventImpl value,
          $Res Function(_$GetVersionEventImpl) then) =
      __$$GetVersionEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetVersionEventImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$GetVersionEventImpl>
    implements _$$GetVersionEventImplCopyWith<$Res> {
  __$$GetVersionEventImplCopyWithImpl(
      _$GetVersionEventImpl _value, $Res Function(_$GetVersionEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetVersionEventImpl
    with DiagnosticableTreeMixin
    implements GetVersionEvent {
  const _$GetVersionEventImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsEvent.getVersion()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'SettingsEvent.getVersion'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetVersionEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getVersion,
    required TResult Function() clearData,
  }) {
    return getVersion();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getVersion,
    TResult? Function()? clearData,
  }) {
    return getVersion?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getVersion,
    TResult Function()? clearData,
    required TResult orElse(),
  }) {
    if (getVersion != null) {
      return getVersion();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetVersionEvent value) getVersion,
    required TResult Function(ClearDataEvent value) clearData,
  }) {
    return getVersion(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetVersionEvent value)? getVersion,
    TResult? Function(ClearDataEvent value)? clearData,
  }) {
    return getVersion?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetVersionEvent value)? getVersion,
    TResult Function(ClearDataEvent value)? clearData,
    required TResult orElse(),
  }) {
    if (getVersion != null) {
      return getVersion(this);
    }
    return orElse();
  }
}

abstract class GetVersionEvent implements SettingsEvent {
  const factory GetVersionEvent() = _$GetVersionEventImpl;
}

/// @nodoc
abstract class _$$ClearDataEventImplCopyWith<$Res> {
  factory _$$ClearDataEventImplCopyWith(_$ClearDataEventImpl value,
          $Res Function(_$ClearDataEventImpl) then) =
      __$$ClearDataEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearDataEventImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$ClearDataEventImpl>
    implements _$$ClearDataEventImplCopyWith<$Res> {
  __$$ClearDataEventImplCopyWithImpl(
      _$ClearDataEventImpl _value, $Res Function(_$ClearDataEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearDataEventImpl
    with DiagnosticableTreeMixin
    implements ClearDataEvent {
  const _$ClearDataEventImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsEvent.clearData()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'SettingsEvent.clearData'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearDataEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getVersion,
    required TResult Function() clearData,
  }) {
    return clearData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getVersion,
    TResult? Function()? clearData,
  }) {
    return clearData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getVersion,
    TResult Function()? clearData,
    required TResult orElse(),
  }) {
    if (clearData != null) {
      return clearData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetVersionEvent value) getVersion,
    required TResult Function(ClearDataEvent value) clearData,
  }) {
    return clearData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetVersionEvent value)? getVersion,
    TResult? Function(ClearDataEvent value)? clearData,
  }) {
    return clearData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetVersionEvent value)? getVersion,
    TResult Function(ClearDataEvent value)? clearData,
    required TResult orElse(),
  }) {
    if (clearData != null) {
      return clearData(this);
    }
    return orElse();
  }
}

abstract class ClearDataEvent implements SettingsEvent {
  const factory ClearDataEvent() = _$ClearDataEventImpl;
}

/// @nodoc
mixin _$SettingsState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(String message) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(String message)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StateInitial<T> value) initial,
    required TResult Function(StateLoading<T> value) loading,
    required TResult Function(StateSuccess<T> value) success,
    required TResult Function(StateFailure<T> value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial<T> value)? initial,
    TResult? Function(StateLoading<T> value)? loading,
    TResult? Function(StateSuccess<T> value)? success,
    TResult? Function(StateFailure<T> value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial<T> value)? initial,
    TResult Function(StateLoading<T> value)? loading,
    TResult Function(StateSuccess<T> value)? success,
    TResult Function(StateFailure<T> value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<T, $Res> {
  factory $SettingsStateCopyWith(
          SettingsState<T> value, $Res Function(SettingsState<T>) then) =
      _$SettingsStateCopyWithImpl<T, $Res, SettingsState<T>>;
}

/// @nodoc
class _$SettingsStateCopyWithImpl<T, $Res, $Val extends SettingsState<T>>
    implements $SettingsStateCopyWith<T, $Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StateInitialImplCopyWith<T, $Res> {
  factory _$$StateInitialImplCopyWith(_$StateInitialImpl<T> value,
          $Res Function(_$StateInitialImpl<T>) then) =
      __$$StateInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$StateInitialImplCopyWithImpl<T, $Res>
    extends _$SettingsStateCopyWithImpl<T, $Res, _$StateInitialImpl<T>>
    implements _$$StateInitialImplCopyWith<T, $Res> {
  __$$StateInitialImplCopyWithImpl(
      _$StateInitialImpl<T> _value, $Res Function(_$StateInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StateInitialImpl<T>
    with DiagnosticableTreeMixin
    implements StateInitial<T> {
  const _$StateInitialImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsState<$T>.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'SettingsState<$T>.initial'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StateInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(String message) failure,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(String message)? failure,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StateInitial<T> value) initial,
    required TResult Function(StateLoading<T> value) loading,
    required TResult Function(StateSuccess<T> value) success,
    required TResult Function(StateFailure<T> value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial<T> value)? initial,
    TResult? Function(StateLoading<T> value)? loading,
    TResult? Function(StateSuccess<T> value)? success,
    TResult? Function(StateFailure<T> value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial<T> value)? initial,
    TResult Function(StateLoading<T> value)? loading,
    TResult Function(StateSuccess<T> value)? success,
    TResult Function(StateFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class StateInitial<T> implements SettingsState<T> {
  const factory StateInitial() = _$StateInitialImpl<T>;
}

/// @nodoc
abstract class _$$StateLoadingImplCopyWith<T, $Res> {
  factory _$$StateLoadingImplCopyWith(_$StateLoadingImpl<T> value,
          $Res Function(_$StateLoadingImpl<T>) then) =
      __$$StateLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$StateLoadingImplCopyWithImpl<T, $Res>
    extends _$SettingsStateCopyWithImpl<T, $Res, _$StateLoadingImpl<T>>
    implements _$$StateLoadingImplCopyWith<T, $Res> {
  __$$StateLoadingImplCopyWithImpl(
      _$StateLoadingImpl<T> _value, $Res Function(_$StateLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StateLoadingImpl<T>
    with DiagnosticableTreeMixin
    implements StateLoading<T> {
  const _$StateLoadingImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsState<$T>.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'SettingsState<$T>.loading'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StateLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(String message) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(String message)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StateInitial<T> value) initial,
    required TResult Function(StateLoading<T> value) loading,
    required TResult Function(StateSuccess<T> value) success,
    required TResult Function(StateFailure<T> value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial<T> value)? initial,
    TResult? Function(StateLoading<T> value)? loading,
    TResult? Function(StateSuccess<T> value)? success,
    TResult? Function(StateFailure<T> value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial<T> value)? initial,
    TResult Function(StateLoading<T> value)? loading,
    TResult Function(StateSuccess<T> value)? success,
    TResult Function(StateFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class StateLoading<T> implements SettingsState<T> {
  const factory StateLoading() = _$StateLoadingImpl<T>;
}

/// @nodoc
abstract class _$$StateSuccessImplCopyWith<T, $Res> {
  factory _$$StateSuccessImplCopyWith(_$StateSuccessImpl<T> value,
          $Res Function(_$StateSuccessImpl<T>) then) =
      __$$StateSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$StateSuccessImplCopyWithImpl<T, $Res>
    extends _$SettingsStateCopyWithImpl<T, $Res, _$StateSuccessImpl<T>>
    implements _$$StateSuccessImplCopyWith<T, $Res> {
  __$$StateSuccessImplCopyWithImpl(
      _$StateSuccessImpl<T> _value, $Res Function(_$StateSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$StateSuccessImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$StateSuccessImpl<T>
    with DiagnosticableTreeMixin
    implements StateSuccess<T> {
  const _$StateSuccessImpl(this.data);

  @override
  final T data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsState<$T>.success(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SettingsState<$T>.success'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateSuccessImplCopyWith<T, _$StateSuccessImpl<T>> get copyWith =>
      __$$StateSuccessImplCopyWithImpl<T, _$StateSuccessImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(String message) failure,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(String message)? failure,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StateInitial<T> value) initial,
    required TResult Function(StateLoading<T> value) loading,
    required TResult Function(StateSuccess<T> value) success,
    required TResult Function(StateFailure<T> value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial<T> value)? initial,
    TResult? Function(StateLoading<T> value)? loading,
    TResult? Function(StateSuccess<T> value)? success,
    TResult? Function(StateFailure<T> value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial<T> value)? initial,
    TResult Function(StateLoading<T> value)? loading,
    TResult Function(StateSuccess<T> value)? success,
    TResult Function(StateFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class StateSuccess<T> implements SettingsState<T> {
  const factory StateSuccess(final T data) = _$StateSuccessImpl<T>;

  T get data;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateSuccessImplCopyWith<T, _$StateSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StateFailureImplCopyWith<T, $Res> {
  factory _$$StateFailureImplCopyWith(_$StateFailureImpl<T> value,
          $Res Function(_$StateFailureImpl<T>) then) =
      __$$StateFailureImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StateFailureImplCopyWithImpl<T, $Res>
    extends _$SettingsStateCopyWithImpl<T, $Res, _$StateFailureImpl<T>>
    implements _$$StateFailureImplCopyWith<T, $Res> {
  __$$StateFailureImplCopyWithImpl(
      _$StateFailureImpl<T> _value, $Res Function(_$StateFailureImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$StateFailureImpl<T>(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StateFailureImpl<T>
    with DiagnosticableTreeMixin
    implements StateFailure<T> {
  const _$StateFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsState<$T>.failure(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SettingsState<$T>.failure'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateFailureImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateFailureImplCopyWith<T, _$StateFailureImpl<T>> get copyWith =>
      __$$StateFailureImplCopyWithImpl<T, _$StateFailureImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(String message) failure,
  }) {
    return failure(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(String message)? failure,
  }) {
    return failure?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StateInitial<T> value) initial,
    required TResult Function(StateLoading<T> value) loading,
    required TResult Function(StateSuccess<T> value) success,
    required TResult Function(StateFailure<T> value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial<T> value)? initial,
    TResult? Function(StateLoading<T> value)? loading,
    TResult? Function(StateSuccess<T> value)? success,
    TResult? Function(StateFailure<T> value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial<T> value)? initial,
    TResult Function(StateLoading<T> value)? loading,
    TResult Function(StateSuccess<T> value)? success,
    TResult Function(StateFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class StateFailure<T> implements SettingsState<T> {
  const factory StateFailure(final String message) = _$StateFailureImpl<T>;

  String get message;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateFailureImplCopyWith<T, _$StateFailureImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
