// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_view_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DetailViewEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailViewEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailViewEvent()';
  }
}

/// @nodoc
class $DetailViewEventCopyWith<$Res> {
  $DetailViewEventCopyWith(
      DetailViewEvent _, $Res Function(DetailViewEvent) __);
}

/// @nodoc

class DetailsEvent implements DetailViewEvent {
  const DetailsEvent();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailsEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailViewEvent.details()';
  }
}

/// @nodoc
mixin _$DetailViewState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailViewState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailViewState()';
  }
}

/// @nodoc
class $DetailViewStateCopyWith<$Res> {
  $DetailViewStateCopyWith(
      DetailViewState _, $Res Function(DetailViewState) __);
}

/// @nodoc

class DetailLoading implements DetailViewState {
  const DetailLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DetailLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'DetailViewState.loading()';
  }
}

/// @nodoc

class DetailSuccess implements DetailViewState {
  const DetailSuccess(this.detail);

  final Details detail;

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DetailSuccessCopyWith<DetailSuccess> get copyWith =>
      _$DetailSuccessCopyWithImpl<DetailSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DetailSuccess &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, detail);

  @override
  String toString() {
    return 'DetailViewState.success(detail: $detail)';
  }
}

/// @nodoc
abstract mixin class $DetailSuccessCopyWith<$Res>
    implements $DetailViewStateCopyWith<$Res> {
  factory $DetailSuccessCopyWith(
          DetailSuccess value, $Res Function(DetailSuccess) _then) =
      _$DetailSuccessCopyWithImpl;
  @useResult
  $Res call({Details detail});

  $DetailsCopyWith<$Res> get detail;
}

/// @nodoc
class _$DetailSuccessCopyWithImpl<$Res>
    implements $DetailSuccessCopyWith<$Res> {
  _$DetailSuccessCopyWithImpl(this._self, this._then);

  final DetailSuccess _self;
  final $Res Function(DetailSuccess) _then;

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? detail = null,
  }) {
    return _then(DetailSuccess(
      null == detail
          ? _self.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as Details,
    ));
  }

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailsCopyWith<$Res> get detail {
    return $DetailsCopyWith<$Res>(_self.detail, (value) {
      return _then(_self.copyWith(detail: value));
    });
  }
}

/// @nodoc

class DetailFailed implements DetailViewState {
  const DetailFailed(this.message);

  final String message;

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DetailFailedCopyWith<DetailFailed> get copyWith =>
      _$DetailFailedCopyWithImpl<DetailFailed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DetailFailed &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'DetailViewState.failed(message: $message)';
  }
}

/// @nodoc
abstract mixin class $DetailFailedCopyWith<$Res>
    implements $DetailViewStateCopyWith<$Res> {
  factory $DetailFailedCopyWith(
          DetailFailed value, $Res Function(DetailFailed) _then) =
      _$DetailFailedCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$DetailFailedCopyWithImpl<$Res> implements $DetailFailedCopyWith<$Res> {
  _$DetailFailedCopyWithImpl(this._self, this._then);

  final DetailFailed _self;
  final $Res Function(DetailFailed) _then;

  /// Create a copy of DetailViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(DetailFailed(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
