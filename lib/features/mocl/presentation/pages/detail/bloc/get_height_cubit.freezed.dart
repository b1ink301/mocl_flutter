// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_height_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetHeightState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GetHeightState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GetHeightState()';
  }
}

/// @nodoc
class $GetHeightStateCopyWith<$Res> {
  $GetHeightStateCopyWith(GetHeightState _, $Res Function(GetHeightState) __);
}

/// @nodoc

class InitialGetHeightState implements GetHeightState {
  const InitialGetHeightState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InitialGetHeightState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GetHeightState.initial()';
  }
}

/// @nodoc

class SuccessGetHeightState implements GetHeightState {
  const SuccessGetHeightState(this.height);

  final double height;

  /// Create a copy of GetHeightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SuccessGetHeightStateCopyWith<SuccessGetHeightState> get copyWith =>
      _$SuccessGetHeightStateCopyWithImpl<SuccessGetHeightState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SuccessGetHeightState &&
            (identical(other.height, height) || other.height == height));
  }

  @override
  int get hashCode => Object.hash(runtimeType, height);

  @override
  String toString() {
    return 'GetHeightState.success(height: $height)';
  }
}

/// @nodoc
abstract mixin class $SuccessGetHeightStateCopyWith<$Res>
    implements $GetHeightStateCopyWith<$Res> {
  factory $SuccessGetHeightStateCopyWith(SuccessGetHeightState value,
          $Res Function(SuccessGetHeightState) _then) =
      _$SuccessGetHeightStateCopyWithImpl;
  @useResult
  $Res call({double height});
}

/// @nodoc
class _$SuccessGetHeightStateCopyWithImpl<$Res>
    implements $SuccessGetHeightStateCopyWith<$Res> {
  _$SuccessGetHeightStateCopyWithImpl(this._self, this._then);

  final SuccessGetHeightState _self;
  final $Res Function(SuccessGetHeightState) _then;

  /// Create a copy of GetHeightState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? height = null,
  }) {
    return _then(SuccessGetHeightState(
      null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
