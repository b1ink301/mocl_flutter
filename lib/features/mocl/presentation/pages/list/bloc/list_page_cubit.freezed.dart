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
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasReachedMax => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListPageStateCopyWith<ListPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListPageStateCopyWith<$Res> {
  factory $ListPageStateCopyWith(
          ListPageState value, $Res Function(ListPageState) then) =
      _$ListPageStateCopyWithImpl<$Res, ListPageState>;
  @useResult
  $Res call({bool isLoading, bool hasReachedMax, int count, String? error});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? hasReachedMax = null,
    Object? count = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListPageStateImplCopyWith<$Res>
    implements $ListPageStateCopyWith<$Res> {
  factory _$$ListPageStateImplCopyWith(
          _$ListPageStateImpl value, $Res Function(_$ListPageStateImpl) then) =
      __$$ListPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, bool hasReachedMax, int count, String? error});
}

/// @nodoc
class __$$ListPageStateImplCopyWithImpl<$Res>
    extends _$ListPageStateCopyWithImpl<$Res, _$ListPageStateImpl>
    implements _$$ListPageStateImplCopyWith<$Res> {
  __$$ListPageStateImplCopyWithImpl(
      _$ListPageStateImpl _value, $Res Function(_$ListPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? hasReachedMax = null,
    Object? count = null,
    Object? error = freezed,
  }) {
    return _then(_$ListPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ListPageStateImpl implements _ListPageState {
  const _$ListPageStateImpl(
      {this.isLoading = false,
      this.hasReachedMax = false,
      this.count = 0,
      this.error});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasReachedMax;
  @override
  @JsonKey()
  final int count;
  @override
  final String? error;

  @override
  String toString() {
    return 'ListPageState(isLoading: $isLoading, hasReachedMax: $hasReachedMax, count: $count, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, hasReachedMax, count, error);

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListPageStateImplCopyWith<_$ListPageStateImpl> get copyWith =>
      __$$ListPageStateImplCopyWithImpl<_$ListPageStateImpl>(this, _$identity);
}

abstract class _ListPageState implements ListPageState {
  const factory _ListPageState(
      {final bool isLoading,
      final bool hasReachedMax,
      final int count,
      final String? error}) = _$ListPageStateImpl;

  @override
  bool get isLoading;
  @override
  bool get hasReachedMax;
  @override
  int get count;
  @override
  String? get error;

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListPageStateImplCopyWith<_$ListPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
