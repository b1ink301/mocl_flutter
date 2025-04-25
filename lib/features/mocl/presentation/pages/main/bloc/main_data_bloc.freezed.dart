// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_data_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MainDataEvent {
  SiteType get siteType;

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MainDataEventCopyWith<MainDataEvent> get copyWith =>
      _$MainDataEventCopyWithImpl<MainDataEvent>(
          this as MainDataEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MainDataEvent &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, siteType);

  @override
  String toString() {
    return 'MainDataEvent(siteType: $siteType)';
  }
}

/// @nodoc
abstract mixin class $MainDataEventCopyWith<$Res> {
  factory $MainDataEventCopyWith(
          MainDataEvent value, $Res Function(MainDataEvent) _then) =
      _$MainDataEventCopyWithImpl;
  @useResult
  $Res call({SiteType siteType});
}

/// @nodoc
class _$MainDataEventCopyWithImpl<$Res>
    implements $MainDataEventCopyWith<$Res> {
  _$MainDataEventCopyWithImpl(this._self, this._then);

  final MainDataEvent _self;
  final $Res Function(MainDataEvent) _then;

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
  }) {
    return _then(_self.copyWith(
      siteType: null == siteType
          ? _self.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
    ));
  }
}

/// @nodoc

class GetListEvent implements MainDataEvent {
  const GetListEvent({required this.siteType});

  @override
  final SiteType siteType;

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetListEventCopyWith<GetListEvent> get copyWith =>
      _$GetListEventCopyWithImpl<GetListEvent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetListEvent &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, siteType);

  @override
  String toString() {
    return 'MainDataEvent.getList(siteType: $siteType)';
  }
}

/// @nodoc
abstract mixin class $GetListEventCopyWith<$Res>
    implements $MainDataEventCopyWith<$Res> {
  factory $GetListEventCopyWith(
          GetListEvent value, $Res Function(GetListEvent) _then) =
      _$GetListEventCopyWithImpl;
  @override
  @useResult
  $Res call({SiteType siteType});
}

/// @nodoc
class _$GetListEventCopyWithImpl<$Res> implements $GetListEventCopyWith<$Res> {
  _$GetListEventCopyWithImpl(this._self, this._then);

  final GetListEvent _self;
  final $Res Function(GetListEvent) _then;

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? siteType = null,
  }) {
    return _then(GetListEvent(
      siteType: null == siteType
          ? _self.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
    ));
  }
}

/// @nodoc
mixin _$MainDataState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MainDataState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MainDataState()';
  }
}

/// @nodoc
class $MainDataStateCopyWith<$Res> {
  $MainDataStateCopyWith(MainDataState _, $Res Function(MainDataState) __);
}

/// @nodoc

class StateInitial implements MainDataState {
  const StateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is StateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MainDataState.initial()';
  }
}

/// @nodoc

class StateLoading implements MainDataState {
  const StateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is StateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MainDataState.loading()';
  }
}

/// @nodoc

class StateSuccess implements MainDataState {
  const StateSuccess(final List<MainItem> data) : _data = data;

  final List<MainItem> _data;
  List<MainItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StateSuccessCopyWith<StateSuccess> get copyWith =>
      _$StateSuccessCopyWithImpl<StateSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateSuccess &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @override
  String toString() {
    return 'MainDataState.success(data: $data)';
  }
}

/// @nodoc
abstract mixin class $StateSuccessCopyWith<$Res>
    implements $MainDataStateCopyWith<$Res> {
  factory $StateSuccessCopyWith(
          StateSuccess value, $Res Function(StateSuccess) _then) =
      _$StateSuccessCopyWithImpl;
  @useResult
  $Res call({List<MainItem> data});
}

/// @nodoc
class _$StateSuccessCopyWithImpl<$Res> implements $StateSuccessCopyWith<$Res> {
  _$StateSuccessCopyWithImpl(this._self, this._then);

  final StateSuccess _self;
  final $Res Function(StateSuccess) _then;

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? data = null,
  }) {
    return _then(StateSuccess(
      null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MainItem>,
    ));
  }
}

/// @nodoc

class StateFailure implements MainDataState {
  const StateFailure(this.message);

  final String message;

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StateFailureCopyWith<StateFailure> get copyWith =>
      _$StateFailureCopyWithImpl<StateFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateFailure &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'MainDataState.failure(message: $message)';
  }
}

/// @nodoc
abstract mixin class $StateFailureCopyWith<$Res>
    implements $MainDataStateCopyWith<$Res> {
  factory $StateFailureCopyWith(
          StateFailure value, $Res Function(StateFailure) _then) =
      _$StateFailureCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$StateFailureCopyWithImpl<$Res> implements $StateFailureCopyWith<$Res> {
  _$StateFailureCopyWithImpl(this._self, this._then);

  final StateFailure _self;
  final $Res Function(StateFailure) _then;

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(StateFailure(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class StateRequireLogin implements MainDataState {
  const StateRequireLogin(this.message);

  final String message;

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StateRequireLoginCopyWith<StateRequireLogin> get copyWith =>
      _$StateRequireLoginCopyWithImpl<StateRequireLogin>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateRequireLogin &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'MainDataState.requireLogin(message: $message)';
  }
}

/// @nodoc
abstract mixin class $StateRequireLoginCopyWith<$Res>
    implements $MainDataStateCopyWith<$Res> {
  factory $StateRequireLoginCopyWith(
          StateRequireLogin value, $Res Function(StateRequireLogin) _then) =
      _$StateRequireLoginCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$StateRequireLoginCopyWithImpl<$Res>
    implements $StateRequireLoginCopyWith<$Res> {
  _$StateRequireLoginCopyWithImpl(this._self, this._then);

  final StateRequireLogin _self;
  final $Res Function(StateRequireLogin) _then;

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(StateRequireLogin(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
