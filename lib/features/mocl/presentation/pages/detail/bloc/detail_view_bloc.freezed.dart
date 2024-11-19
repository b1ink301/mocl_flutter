// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_view_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DetailViewEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() details,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? details,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? details,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DetailsEvent value) details,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DetailsEvent value)? details,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DetailsEvent value)? details,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailViewEventCopyWith<$Res> {
  factory $DetailViewEventCopyWith(
          DetailViewEvent value, $Res Function(DetailViewEvent) then) =
      _$DetailViewEventCopyWithImpl<$Res, DetailViewEvent>;
}

/// @nodoc
class _$DetailViewEventCopyWithImpl<$Res, $Val extends DetailViewEvent>
    implements $DetailViewEventCopyWith<$Res> {
  _$DetailViewEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailViewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DetailsEventImplCopyWith<$Res> {
  factory _$$DetailsEventImplCopyWith(
          _$DetailsEventImpl value, $Res Function(_$DetailsEventImpl) then) =
      __$$DetailsEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DetailsEventImplCopyWithImpl<$Res>
    extends _$DetailViewEventCopyWithImpl<$Res, _$DetailsEventImpl>
    implements _$$DetailsEventImplCopyWith<$Res> {
  __$$DetailsEventImplCopyWithImpl(
      _$DetailsEventImpl _value, $Res Function(_$DetailsEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailViewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DetailsEventImpl implements DetailsEvent {
  const _$DetailsEventImpl();

  @override
  String toString() {
    return 'DetailViewEvent.details()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DetailsEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() details,
  }) {
    return details();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? details,
  }) {
    return details?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? details,
    required TResult orElse(),
  }) {
    if (details != null) {
      return details();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DetailsEvent value) details,
  }) {
    return details(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DetailsEvent value)? details,
  }) {
    return details?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DetailsEvent value)? details,
    required TResult orElse(),
  }) {
    if (details != null) {
      return details(this);
    }
    return orElse();
  }
}

abstract class DetailsEvent implements DetailViewEvent {
  const factory DetailsEvent() = _$DetailsEventImpl;
}

/// @nodoc
mixin _$DetailViewState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Details detail) success,
    required TResult Function(String message) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Details detail)? success,
    TResult? Function(String message)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Details detail)? success,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DetailLoading value) loading,
    required TResult Function(DetailSuccess value) success,
    required TResult Function(DetailFailed value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DetailLoading value)? loading,
    TResult? Function(DetailSuccess value)? success,
    TResult? Function(DetailFailed value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DetailLoading value)? loading,
    TResult Function(DetailSuccess value)? success,
    TResult Function(DetailFailed value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailViewStateCopyWith<$Res> {
  factory $DetailViewStateCopyWith(
          DetailViewState value, $Res Function(DetailViewState) then) =
      _$DetailViewStateCopyWithImpl<$Res, DetailViewState>;
}

/// @nodoc
class _$DetailViewStateCopyWithImpl<$Res, $Val extends DetailViewState>
    implements $DetailViewStateCopyWith<$Res> {
  _$DetailViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DetailLoadingImplCopyWith<$Res> {
  factory _$$DetailLoadingImplCopyWith(
          _$DetailLoadingImpl value, $Res Function(_$DetailLoadingImpl) then) =
      __$$DetailLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DetailLoadingImplCopyWithImpl<$Res>
    extends _$DetailViewStateCopyWithImpl<$Res, _$DetailLoadingImpl>
    implements _$$DetailLoadingImplCopyWith<$Res> {
  __$$DetailLoadingImplCopyWithImpl(
      _$DetailLoadingImpl _value, $Res Function(_$DetailLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DetailLoadingImpl implements DetailLoading {
  const _$DetailLoadingImpl();

  @override
  String toString() {
    return 'DetailViewState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DetailLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Details detail) success,
    required TResult Function(String message) failed,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Details detail)? success,
    TResult? Function(String message)? failed,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Details detail)? success,
    TResult Function(String message)? failed,
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
    required TResult Function(DetailLoading value) loading,
    required TResult Function(DetailSuccess value) success,
    required TResult Function(DetailFailed value) failed,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DetailLoading value)? loading,
    TResult? Function(DetailSuccess value)? success,
    TResult? Function(DetailFailed value)? failed,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DetailLoading value)? loading,
    TResult Function(DetailSuccess value)? success,
    TResult Function(DetailFailed value)? failed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DetailLoading implements DetailViewState {
  const factory DetailLoading() = _$DetailLoadingImpl;
}

/// @nodoc
abstract class _$$DetailSuccessImplCopyWith<$Res> {
  factory _$$DetailSuccessImplCopyWith(
          _$DetailSuccessImpl value, $Res Function(_$DetailSuccessImpl) then) =
      __$$DetailSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Details detail});

  $DetailsCopyWith<$Res> get detail;
}

/// @nodoc
class __$$DetailSuccessImplCopyWithImpl<$Res>
    extends _$DetailViewStateCopyWithImpl<$Res, _$DetailSuccessImpl>
    implements _$$DetailSuccessImplCopyWith<$Res> {
  __$$DetailSuccessImplCopyWithImpl(
      _$DetailSuccessImpl _value, $Res Function(_$DetailSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? detail = null,
  }) {
    return _then(_$DetailSuccessImpl(
      null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as Details,
    ));
  }

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailsCopyWith<$Res> get detail {
    return $DetailsCopyWith<$Res>(_value.detail, (value) {
      return _then(_value.copyWith(detail: value));
    });
  }
}

/// @nodoc

class _$DetailSuccessImpl implements DetailSuccess {
  const _$DetailSuccessImpl(this.detail);

  @override
  final Details detail;

  @override
  String toString() {
    return 'DetailViewState.success(detail: $detail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailSuccessImpl &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, detail);

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailSuccessImplCopyWith<_$DetailSuccessImpl> get copyWith =>
      __$$DetailSuccessImplCopyWithImpl<_$DetailSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Details detail) success,
    required TResult Function(String message) failed,
  }) {
    return success(detail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Details detail)? success,
    TResult? Function(String message)? failed,
  }) {
    return success?.call(detail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Details detail)? success,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(detail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DetailLoading value) loading,
    required TResult Function(DetailSuccess value) success,
    required TResult Function(DetailFailed value) failed,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DetailLoading value)? loading,
    TResult? Function(DetailSuccess value)? success,
    TResult? Function(DetailFailed value)? failed,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DetailLoading value)? loading,
    TResult Function(DetailSuccess value)? success,
    TResult Function(DetailFailed value)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class DetailSuccess implements DetailViewState {
  const factory DetailSuccess(final Details detail) = _$DetailSuccessImpl;

  Details get detail;

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailSuccessImplCopyWith<_$DetailSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DetailFailedImplCopyWith<$Res> {
  factory _$$DetailFailedImplCopyWith(
          _$DetailFailedImpl value, $Res Function(_$DetailFailedImpl) then) =
      __$$DetailFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DetailFailedImplCopyWithImpl<$Res>
    extends _$DetailViewStateCopyWithImpl<$Res, _$DetailFailedImpl>
    implements _$$DetailFailedImplCopyWith<$Res> {
  __$$DetailFailedImplCopyWithImpl(
      _$DetailFailedImpl _value, $Res Function(_$DetailFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$DetailFailedImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DetailFailedImpl implements DetailFailed {
  const _$DetailFailedImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'DetailViewState.failed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailFailedImplCopyWith<_$DetailFailedImpl> get copyWith =>
      __$$DetailFailedImplCopyWithImpl<_$DetailFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Details detail) success,
    required TResult Function(String message) failed,
  }) {
    return failed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Details detail)? success,
    TResult? Function(String message)? failed,
  }) {
    return failed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Details detail)? success,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DetailLoading value) loading,
    required TResult Function(DetailSuccess value) success,
    required TResult Function(DetailFailed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DetailLoading value)? loading,
    TResult? Function(DetailSuccess value)? success,
    TResult? Function(DetailFailed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DetailLoading value)? loading,
    TResult Function(DetailSuccess value)? success,
    TResult Function(DetailFailed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class DetailFailed implements DetailViewState {
  const factory DetailFailed(final String message) = _$DetailFailedImpl;

  String get message;

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailFailedImplCopyWith<_$DetailFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
