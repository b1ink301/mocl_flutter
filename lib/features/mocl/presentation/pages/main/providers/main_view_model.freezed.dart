// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MainState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data) success,
    required TResult Function(String message) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data)? success,
    TResult? Function(String message)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MainStateInitial value) initial,
    required TResult Function(MainStateLoading value) loading,
    required TResult Function(MainStateSuccess value) success,
    required TResult Function(MainStateFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MainStateInitial value)? initial,
    TResult? Function(MainStateLoading value)? loading,
    TResult? Function(MainStateSuccess value)? success,
    TResult? Function(MainStateFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MainStateInitial value)? initial,
    TResult Function(MainStateLoading value)? loading,
    TResult Function(MainStateSuccess value)? success,
    TResult Function(MainStateFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainStateCopyWith<$Res> {
  factory $MainStateCopyWith(MainState value, $Res Function(MainState) then) =
      _$MainStateCopyWithImpl<$Res, MainState>;
}

/// @nodoc
class _$MainStateCopyWithImpl<$Res, $Val extends MainState>
    implements $MainStateCopyWith<$Res> {
  _$MainStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MainStateInitialImplCopyWith<$Res> {
  factory _$$MainStateInitialImplCopyWith(_$MainStateInitialImpl value,
          $Res Function(_$MainStateInitialImpl) then) =
      __$$MainStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MainStateInitialImplCopyWithImpl<$Res>
    extends _$MainStateCopyWithImpl<$Res, _$MainStateInitialImpl>
    implements _$$MainStateInitialImplCopyWith<$Res> {
  __$$MainStateInitialImplCopyWithImpl(_$MainStateInitialImpl _value,
      $Res Function(_$MainStateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$MainStateInitialImpl implements MainStateInitial {
  const _$MainStateInitialImpl();

  @override
  String toString() {
    return 'MainState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MainStateInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data) success,
    required TResult Function(String message) failure,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data)? success,
    TResult? Function(String message)? failure,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data)? success,
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
    required TResult Function(MainStateInitial value) initial,
    required TResult Function(MainStateLoading value) loading,
    required TResult Function(MainStateSuccess value) success,
    required TResult Function(MainStateFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MainStateInitial value)? initial,
    TResult? Function(MainStateLoading value)? loading,
    TResult? Function(MainStateSuccess value)? success,
    TResult? Function(MainStateFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MainStateInitial value)? initial,
    TResult Function(MainStateLoading value)? loading,
    TResult Function(MainStateSuccess value)? success,
    TResult Function(MainStateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class MainStateInitial implements MainState {
  const factory MainStateInitial() = _$MainStateInitialImpl;
}

/// @nodoc
abstract class _$$MainStateLoadingImplCopyWith<$Res> {
  factory _$$MainStateLoadingImplCopyWith(_$MainStateLoadingImpl value,
          $Res Function(_$MainStateLoadingImpl) then) =
      __$$MainStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MainStateLoadingImplCopyWithImpl<$Res>
    extends _$MainStateCopyWithImpl<$Res, _$MainStateLoadingImpl>
    implements _$$MainStateLoadingImplCopyWith<$Res> {
  __$$MainStateLoadingImplCopyWithImpl(_$MainStateLoadingImpl _value,
      $Res Function(_$MainStateLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$MainStateLoadingImpl implements MainStateLoading {
  const _$MainStateLoadingImpl();

  @override
  String toString() {
    return 'MainState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MainStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data) success,
    required TResult Function(String message) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data)? success,
    TResult? Function(String message)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data)? success,
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
    required TResult Function(MainStateInitial value) initial,
    required TResult Function(MainStateLoading value) loading,
    required TResult Function(MainStateSuccess value) success,
    required TResult Function(MainStateFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MainStateInitial value)? initial,
    TResult? Function(MainStateLoading value)? loading,
    TResult? Function(MainStateSuccess value)? success,
    TResult? Function(MainStateFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MainStateInitial value)? initial,
    TResult Function(MainStateLoading value)? loading,
    TResult Function(MainStateSuccess value)? success,
    TResult Function(MainStateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class MainStateLoading implements MainState {
  const factory MainStateLoading() = _$MainStateLoadingImpl;
}

/// @nodoc
abstract class _$$MainStateSuccessImplCopyWith<$Res> {
  factory _$$MainStateSuccessImplCopyWith(_$MainStateSuccessImpl value,
          $Res Function(_$MainStateSuccessImpl) then) =
      __$$MainStateSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<MainItem> data});
}

/// @nodoc
class __$$MainStateSuccessImplCopyWithImpl<$Res>
    extends _$MainStateCopyWithImpl<$Res, _$MainStateSuccessImpl>
    implements _$$MainStateSuccessImplCopyWith<$Res> {
  __$$MainStateSuccessImplCopyWithImpl(_$MainStateSuccessImpl _value,
      $Res Function(_$MainStateSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$MainStateSuccessImpl(
      null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MainItem>,
    ));
  }
}

/// @nodoc

class _$MainStateSuccessImpl implements MainStateSuccess {
  const _$MainStateSuccessImpl(final List<MainItem> data) : _data = data;

  final List<MainItem> _data;
  @override
  List<MainItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'MainState.success(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainStateSuccessImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MainStateSuccessImplCopyWith<_$MainStateSuccessImpl> get copyWith =>
      __$$MainStateSuccessImplCopyWithImpl<_$MainStateSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data) success,
    required TResult Function(String message) failure,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data)? success,
    TResult? Function(String message)? failure,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data)? success,
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
    required TResult Function(MainStateInitial value) initial,
    required TResult Function(MainStateLoading value) loading,
    required TResult Function(MainStateSuccess value) success,
    required TResult Function(MainStateFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MainStateInitial value)? initial,
    TResult? Function(MainStateLoading value)? loading,
    TResult? Function(MainStateSuccess value)? success,
    TResult? Function(MainStateFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MainStateInitial value)? initial,
    TResult Function(MainStateLoading value)? loading,
    TResult Function(MainStateSuccess value)? success,
    TResult Function(MainStateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class MainStateSuccess implements MainState {
  const factory MainStateSuccess(final List<MainItem> data) =
      _$MainStateSuccessImpl;

  List<MainItem> get data;

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MainStateSuccessImplCopyWith<_$MainStateSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MainStateFailureImplCopyWith<$Res> {
  factory _$$MainStateFailureImplCopyWith(_$MainStateFailureImpl value,
          $Res Function(_$MainStateFailureImpl) then) =
      __$$MainStateFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$MainStateFailureImplCopyWithImpl<$Res>
    extends _$MainStateCopyWithImpl<$Res, _$MainStateFailureImpl>
    implements _$$MainStateFailureImplCopyWith<$Res> {
  __$$MainStateFailureImplCopyWithImpl(_$MainStateFailureImpl _value,
      $Res Function(_$MainStateFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$MainStateFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MainStateFailureImpl implements MainStateFailure {
  const _$MainStateFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MainState.failure(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MainStateFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MainStateFailureImplCopyWith<_$MainStateFailureImpl> get copyWith =>
      __$$MainStateFailureImplCopyWithImpl<_$MainStateFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data) success,
    required TResult Function(String message) failure,
  }) {
    return failure(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data)? success,
    TResult? Function(String message)? failure,
  }) {
    return failure?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data)? success,
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
    required TResult Function(MainStateInitial value) initial,
    required TResult Function(MainStateLoading value) loading,
    required TResult Function(MainStateSuccess value) success,
    required TResult Function(MainStateFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MainStateInitial value)? initial,
    TResult? Function(MainStateLoading value)? loading,
    TResult? Function(MainStateSuccess value)? success,
    TResult? Function(MainStateFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MainStateInitial value)? initial,
    TResult Function(MainStateLoading value)? loading,
    TResult Function(MainStateSuccess value)? success,
    TResult Function(MainStateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class MainStateFailure implements MainState {
  const factory MainStateFailure(final String message) = _$MainStateFailureImpl;

  String get message;

  /// Create a copy of MainState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MainStateFailureImplCopyWith<_$MainStateFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
