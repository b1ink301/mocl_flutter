// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MainViewState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data, String title) success,
    required TResult Function(String message) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data, String title)? success,
    TResult? Function(String message)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data, String title)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StateInitial value) initial,
    required TResult Function(_StateLoading value) loading,
    required TResult Function(_StateSuccess value) success,
    required TResult Function(_StateFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StateInitial value)? initial,
    TResult? Function(_StateLoading value)? loading,
    TResult? Function(_StateSuccess value)? success,
    TResult? Function(_StateFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StateInitial value)? initial,
    TResult Function(_StateLoading value)? loading,
    TResult Function(_StateSuccess value)? success,
    TResult Function(_StateFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainViewStateCopyWith<$Res> {
  factory $MainViewStateCopyWith(
          MainViewState value, $Res Function(MainViewState) then) =
      _$MainViewStateCopyWithImpl<$Res, MainViewState>;
}

/// @nodoc
class _$MainViewStateCopyWithImpl<$Res, $Val extends MainViewState>
    implements $MainViewStateCopyWith<$Res> {
  _$MainViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StateInitialImplCopyWith<$Res> {
  factory _$$StateInitialImplCopyWith(
          _$StateInitialImpl value, $Res Function(_$StateInitialImpl) then) =
      __$$StateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StateInitialImplCopyWithImpl<$Res>
    extends _$MainViewStateCopyWithImpl<$Res, _$StateInitialImpl>
    implements _$$StateInitialImplCopyWith<$Res> {
  __$$StateInitialImplCopyWithImpl(
      _$StateInitialImpl _value, $Res Function(_$StateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StateInitialImpl implements _StateInitial {
  const _$StateInitialImpl();

  @override
  String toString() {
    return 'MainViewState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StateInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data, String title) success,
    required TResult Function(String message) failure,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data, String title)? success,
    TResult? Function(String message)? failure,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data, String title)? success,
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
    required TResult Function(_StateInitial value) initial,
    required TResult Function(_StateLoading value) loading,
    required TResult Function(_StateSuccess value) success,
    required TResult Function(_StateFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StateInitial value)? initial,
    TResult? Function(_StateLoading value)? loading,
    TResult? Function(_StateSuccess value)? success,
    TResult? Function(_StateFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StateInitial value)? initial,
    TResult Function(_StateLoading value)? loading,
    TResult Function(_StateSuccess value)? success,
    TResult Function(_StateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _StateInitial implements MainViewState {
  const factory _StateInitial() = _$StateInitialImpl;
}

/// @nodoc
abstract class _$$StateLoadingImplCopyWith<$Res> {
  factory _$$StateLoadingImplCopyWith(
          _$StateLoadingImpl value, $Res Function(_$StateLoadingImpl) then) =
      __$$StateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StateLoadingImplCopyWithImpl<$Res>
    extends _$MainViewStateCopyWithImpl<$Res, _$StateLoadingImpl>
    implements _$$StateLoadingImplCopyWith<$Res> {
  __$$StateLoadingImplCopyWithImpl(
      _$StateLoadingImpl _value, $Res Function(_$StateLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StateLoadingImpl implements _StateLoading {
  const _$StateLoadingImpl();

  @override
  String toString() {
    return 'MainViewState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data, String title) success,
    required TResult Function(String message) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data, String title)? success,
    TResult? Function(String message)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data, String title)? success,
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
    required TResult Function(_StateInitial value) initial,
    required TResult Function(_StateLoading value) loading,
    required TResult Function(_StateSuccess value) success,
    required TResult Function(_StateFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StateInitial value)? initial,
    TResult? Function(_StateLoading value)? loading,
    TResult? Function(_StateSuccess value)? success,
    TResult? Function(_StateFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StateInitial value)? initial,
    TResult Function(_StateLoading value)? loading,
    TResult Function(_StateSuccess value)? success,
    TResult Function(_StateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _StateLoading implements MainViewState {
  const factory _StateLoading() = _$StateLoadingImpl;
}

/// @nodoc
abstract class _$$StateSuccessImplCopyWith<$Res> {
  factory _$$StateSuccessImplCopyWith(
          _$StateSuccessImpl value, $Res Function(_$StateSuccessImpl) then) =
      __$$StateSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<MainItem> data, String title});
}

/// @nodoc
class __$$StateSuccessImplCopyWithImpl<$Res>
    extends _$MainViewStateCopyWithImpl<$Res, _$StateSuccessImpl>
    implements _$$StateSuccessImplCopyWith<$Res> {
  __$$StateSuccessImplCopyWithImpl(
      _$StateSuccessImpl _value, $Res Function(_$StateSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? title = null,
  }) {
    return _then(_$StateSuccessImpl(
      null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MainItem>,
      null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StateSuccessImpl implements _StateSuccess {
  const _$StateSuccessImpl(final List<MainItem> data, this.title)
      : _data = data;

  final List<MainItem> _data;
  @override
  List<MainItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String title;

  @override
  String toString() {
    return 'MainViewState.success(data: $data, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateSuccessImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), title);

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateSuccessImplCopyWith<_$StateSuccessImpl> get copyWith =>
      __$$StateSuccessImplCopyWithImpl<_$StateSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data, String title) success,
    required TResult Function(String message) failure,
  }) {
    return success(data, title);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data, String title)? success,
    TResult? Function(String message)? failure,
  }) {
    return success?.call(data, title);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data, String title)? success,
    TResult Function(String message)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data, title);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StateInitial value) initial,
    required TResult Function(_StateLoading value) loading,
    required TResult Function(_StateSuccess value) success,
    required TResult Function(_StateFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StateInitial value)? initial,
    TResult? Function(_StateLoading value)? loading,
    TResult? Function(_StateSuccess value)? success,
    TResult? Function(_StateFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StateInitial value)? initial,
    TResult Function(_StateLoading value)? loading,
    TResult Function(_StateSuccess value)? success,
    TResult Function(_StateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _StateSuccess implements MainViewState {
  const factory _StateSuccess(final List<MainItem> data, final String title) =
      _$StateSuccessImpl;

  List<MainItem> get data;
  String get title;

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateSuccessImplCopyWith<_$StateSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StateFailureImplCopyWith<$Res> {
  factory _$$StateFailureImplCopyWith(
          _$StateFailureImpl value, $Res Function(_$StateFailureImpl) then) =
      __$$StateFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StateFailureImplCopyWithImpl<$Res>
    extends _$MainViewStateCopyWithImpl<$Res, _$StateFailureImpl>
    implements _$$StateFailureImplCopyWith<$Res> {
  __$$StateFailureImplCopyWithImpl(
      _$StateFailureImpl _value, $Res Function(_$StateFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$StateFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StateFailureImpl implements _StateFailure {
  const _$StateFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MainViewState.failure(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateFailureImplCopyWith<_$StateFailureImpl> get copyWith =>
      __$$StateFailureImplCopyWithImpl<_$StateFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data, String title) success,
    required TResult Function(String message) failure,
  }) {
    return failure(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data, String title)? success,
    TResult? Function(String message)? failure,
  }) {
    return failure?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data, String title)? success,
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
    required TResult Function(_StateInitial value) initial,
    required TResult Function(_StateLoading value) loading,
    required TResult Function(_StateSuccess value) success,
    required TResult Function(_StateFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StateInitial value)? initial,
    TResult? Function(_StateLoading value)? loading,
    TResult? Function(_StateSuccess value)? success,
    TResult? Function(_StateFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StateInitial value)? initial,
    TResult Function(_StateLoading value)? loading,
    TResult Function(_StateSuccess value)? success,
    TResult Function(_StateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _StateFailure implements MainViewState {
  const factory _StateFailure(final String message) = _$StateFailureImpl;

  String get message;

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateFailureImplCopyWith<_$StateFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
