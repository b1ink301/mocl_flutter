// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_page_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ListPageState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? loaded,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingList value) loading,
    required TResult Function(LoadedList value) loaded,
    required TResult Function(FailedList value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingList value)? loading,
    TResult? Function(LoadedList value)? loaded,
    TResult? Function(FailedList value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingList value)? loading,
    TResult Function(LoadedList value)? loaded,
    TResult Function(FailedList value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListPageStateCopyWith<$Res> {
  factory $ListPageStateCopyWith(
          ListPageState value, $Res Function(ListPageState) then) =
      _$ListPageStateCopyWithImpl<$Res, ListPageState>;
}

/// @nodoc
class _$ListPageStateCopyWithImpl<$Res, $Val extends ListPageState>
    implements $ListPageStateCopyWith<$Res> {
  _$ListPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadingListImplCopyWith<$Res> {
  factory _$$LoadingListImplCopyWith(
          _$LoadingListImpl value, $Res Function(_$LoadingListImpl) then) =
      __$$LoadingListImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingListImplCopyWithImpl<$Res>
    extends _$ListPageStateCopyWithImpl<$Res, _$LoadingListImpl>
    implements _$$LoadingListImplCopyWith<$Res> {
  __$$LoadingListImplCopyWithImpl(
      _$LoadingListImpl _value, $Res Function(_$LoadingListImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingListImpl implements LoadingList {
  const _$LoadingListImpl();

  @override
  String toString() {
    return 'ListPageState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingListImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) failed,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? failed,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? loaded,
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
    required TResult Function(LoadingList value) loading,
    required TResult Function(LoadedList value) loaded,
    required TResult Function(FailedList value) failed,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingList value)? loading,
    TResult? Function(LoadedList value)? loaded,
    TResult? Function(FailedList value)? failed,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingList value)? loading,
    TResult Function(LoadedList value)? loaded,
    TResult Function(FailedList value)? failed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LoadingList implements ListPageState {
  const factory LoadingList() = _$LoadingListImpl;
}

/// @nodoc
abstract class _$$LoadedListImplCopyWith<$Res> {
  factory _$$LoadedListImplCopyWith(
          _$LoadedListImpl value, $Res Function(_$LoadedListImpl) then) =
      __$$LoadedListImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadedListImplCopyWithImpl<$Res>
    extends _$ListPageStateCopyWithImpl<$Res, _$LoadedListImpl>
    implements _$$LoadedListImplCopyWith<$Res> {
  __$$LoadedListImplCopyWithImpl(
      _$LoadedListImpl _value, $Res Function(_$LoadedListImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadedListImpl implements LoadedList {
  const _$LoadedListImpl();

  @override
  String toString() {
    return 'ListPageState.loaded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadedListImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) failed,
  }) {
    return loaded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? failed,
  }) {
    return loaded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? loaded,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingList value) loading,
    required TResult Function(LoadedList value) loaded,
    required TResult Function(FailedList value) failed,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingList value)? loading,
    TResult? Function(LoadedList value)? loaded,
    TResult? Function(FailedList value)? failed,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingList value)? loading,
    TResult Function(LoadedList value)? loaded,
    TResult Function(FailedList value)? failed,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class LoadedList implements ListPageState {
  const factory LoadedList() = _$LoadedListImpl;
}

/// @nodoc
abstract class _$$FailedListImplCopyWith<$Res> {
  factory _$$FailedListImplCopyWith(
          _$FailedListImpl value, $Res Function(_$FailedListImpl) then) =
      __$$FailedListImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FailedListImplCopyWithImpl<$Res>
    extends _$ListPageStateCopyWithImpl<$Res, _$FailedListImpl>
    implements _$$FailedListImplCopyWith<$Res> {
  __$$FailedListImplCopyWithImpl(
      _$FailedListImpl _value, $Res Function(_$FailedListImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FailedListImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FailedListImpl implements FailedList {
  const _$FailedListImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ListPageState.failed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailedListImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailedListImplCopyWith<_$FailedListImpl> get copyWith =>
      __$$FailedListImplCopyWithImpl<_$FailedListImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) failed,
  }) {
    return failed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? failed,
  }) {
    return failed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function()? loaded,
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
    required TResult Function(LoadingList value) loading,
    required TResult Function(LoadedList value) loaded,
    required TResult Function(FailedList value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingList value)? loading,
    TResult? Function(LoadedList value)? loaded,
    TResult? Function(FailedList value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingList value)? loading,
    TResult Function(LoadedList value)? loaded,
    TResult Function(FailedList value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class FailedList implements ListPageState {
  const factory FailedList(final String message) = _$FailedListImpl;

  String get message;

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailedListImplCopyWith<_$FailedListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ListPageSideEffect {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() test,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? test,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? test,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ListTest value) test,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ListTest value)? test,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ListTest value)? test,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListPageSideEffectCopyWith<$Res> {
  factory $ListPageSideEffectCopyWith(
          ListPageSideEffect value, $Res Function(ListPageSideEffect) then) =
      _$ListPageSideEffectCopyWithImpl<$Res, ListPageSideEffect>;
}

/// @nodoc
class _$ListPageSideEffectCopyWithImpl<$Res, $Val extends ListPageSideEffect>
    implements $ListPageSideEffectCopyWith<$Res> {
  _$ListPageSideEffectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListPageSideEffect
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ListTestImplCopyWith<$Res> {
  factory _$$ListTestImplCopyWith(
          _$ListTestImpl value, $Res Function(_$ListTestImpl) then) =
      __$$ListTestImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ListTestImplCopyWithImpl<$Res>
    extends _$ListPageSideEffectCopyWithImpl<$Res, _$ListTestImpl>
    implements _$$ListTestImplCopyWith<$Res> {
  __$$ListTestImplCopyWithImpl(
      _$ListTestImpl _value, $Res Function(_$ListTestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListPageSideEffect
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ListTestImpl implements ListTest {
  const _$ListTestImpl();

  @override
  String toString() {
    return 'ListPageSideEffect.test()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ListTestImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() test,
  }) {
    return test();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? test,
  }) {
    return test?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? test,
    required TResult orElse(),
  }) {
    if (test != null) {
      return test();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ListTest value) test,
  }) {
    return test(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ListTest value)? test,
  }) {
    return test?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ListTest value)? test,
    required TResult orElse(),
  }) {
    if (test != null) {
      return test(this);
    }
    return orElse();
  }
}

abstract class ListTest implements ListPageSideEffect {
  const factory ListTest() = _$ListTestImpl;
}
