// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_version_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetVersionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetVersionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetVersionState()';
}


}

/// @nodoc
class $GetVersionStateCopyWith<$Res>  {
$GetVersionStateCopyWith(GetVersionState _, $Res Function(GetVersionState) __);
}


/// @nodoc


class InitialGetVersionState implements GetVersionState {
  const InitialGetVersionState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialGetVersionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetVersionState.initial()';
}


}




/// @nodoc


class LoadingGetVersionState implements GetVersionState {
  const LoadingGetVersionState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadingGetVersionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GetVersionState.loading()';
}


}




/// @nodoc


class SuccessGetVersionState implements GetVersionState {
  const SuccessGetVersionState(this.version);
  

 final  String version;

/// Create a copy of GetVersionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessGetVersionStateCopyWith<SuccessGetVersionState> get copyWith => _$SuccessGetVersionStateCopyWithImpl<SuccessGetVersionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessGetVersionState&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,version);

@override
String toString() {
  return 'GetVersionState.success(version: $version)';
}


}

/// @nodoc
abstract mixin class $SuccessGetVersionStateCopyWith<$Res> implements $GetVersionStateCopyWith<$Res> {
  factory $SuccessGetVersionStateCopyWith(SuccessGetVersionState value, $Res Function(SuccessGetVersionState) _then) = _$SuccessGetVersionStateCopyWithImpl;
@useResult
$Res call({
 String version
});




}
/// @nodoc
class _$SuccessGetVersionStateCopyWithImpl<$Res>
    implements $SuccessGetVersionStateCopyWith<$Res> {
  _$SuccessGetVersionStateCopyWithImpl(this._self, this._then);

  final SuccessGetVersionState _self;
  final $Res Function(SuccessGetVersionState) _then;

/// Create a copy of GetVersionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? version = null,}) {
  return _then(SuccessGetVersionState(
null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FailureGetVersionState implements GetVersionState {
  const FailureGetVersionState(this.errorMessage);
  

 final  String errorMessage;

/// Create a copy of GetVersionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureGetVersionStateCopyWith<FailureGetVersionState> get copyWith => _$FailureGetVersionStateCopyWithImpl<FailureGetVersionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FailureGetVersionState&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,errorMessage);

@override
String toString() {
  return 'GetVersionState.failure(errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FailureGetVersionStateCopyWith<$Res> implements $GetVersionStateCopyWith<$Res> {
  factory $FailureGetVersionStateCopyWith(FailureGetVersionState value, $Res Function(FailureGetVersionState) _then) = _$FailureGetVersionStateCopyWithImpl;
@useResult
$Res call({
 String errorMessage
});




}
/// @nodoc
class _$FailureGetVersionStateCopyWithImpl<$Res>
    implements $FailureGetVersionStateCopyWith<$Res> {
  _$FailureGetVersionStateCopyWithImpl(this._self, this._then);

  final FailureGetVersionState _self;
  final $Res Function(FailureGetVersionState) _then;

/// Create a copy of GetVersionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMessage = null,}) {
  return _then(FailureGetVersionState(
null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
