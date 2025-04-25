// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_page_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListPageState {
  bool get isLoading;
  bool get hasReachedMax;
  int get count;
  String? get error;

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListPageStateCopyWith<ListPageState> get copyWith =>
      _$ListPageStateCopyWithImpl<ListPageState>(
          this as ListPageState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListPageState &&
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

  @override
  String toString() {
    return 'ListPageState(isLoading: $isLoading, hasReachedMax: $hasReachedMax, count: $count, error: $error)';
  }
}

/// @nodoc
abstract mixin class $ListPageStateCopyWith<$Res> {
  factory $ListPageStateCopyWith(
          ListPageState value, $Res Function(ListPageState) _then) =
      _$ListPageStateCopyWithImpl;
  @useResult
  $Res call({bool isLoading, bool hasReachedMax, int count, String? error});
}

/// @nodoc
class _$ListPageStateCopyWithImpl<$Res>
    implements $ListPageStateCopyWith<$Res> {
  _$ListPageStateCopyWithImpl(this._self, this._then);

  final ListPageState _self;
  final $Res Function(ListPageState) _then;

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
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReachedMax: null == hasReachedMax
          ? _self.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _ListPageState implements ListPageState {
  const _ListPageState(
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

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ListPageStateCopyWith<_ListPageState> get copyWith =>
      __$ListPageStateCopyWithImpl<_ListPageState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ListPageState &&
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

  @override
  String toString() {
    return 'ListPageState(isLoading: $isLoading, hasReachedMax: $hasReachedMax, count: $count, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$ListPageStateCopyWith<$Res>
    implements $ListPageStateCopyWith<$Res> {
  factory _$ListPageStateCopyWith(
          _ListPageState value, $Res Function(_ListPageState) _then) =
      __$ListPageStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isLoading, bool hasReachedMax, int count, String? error});
}

/// @nodoc
class __$ListPageStateCopyWithImpl<$Res>
    implements _$ListPageStateCopyWith<$Res> {
  __$ListPageStateCopyWithImpl(this._self, this._then);

  final _ListPageState _self;
  final $Res Function(_ListPageState) _then;

  /// Create a copy of ListPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? hasReachedMax = null,
    Object? count = null,
    Object? error = freezed,
  }) {
    return _then(_ListPageState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasReachedMax: null == hasReachedMax
          ? _self.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
