// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_data_json_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MainDataJsonEvent {
  SiteType get siteType => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SiteType siteType) getList,
    required TResult Function(SiteType siteType, List<MainItem> list) addList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SiteType siteType)? getList,
    TResult? Function(SiteType siteType, List<MainItem> list)? addList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SiteType siteType)? getList,
    TResult Function(SiteType siteType, List<MainItem> list)? addList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetListEvent value) getList,
    required TResult Function(AddListEvent value) addList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetListEvent value)? getList,
    TResult? Function(AddListEvent value)? addList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetListEvent value)? getList,
    TResult Function(AddListEvent value)? addList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of MainDataJsonEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MainDataJsonEventCopyWith<MainDataJsonEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainDataJsonEventCopyWith<$Res> {
  factory $MainDataJsonEventCopyWith(
          MainDataJsonEvent value, $Res Function(MainDataJsonEvent) then) =
      _$MainDataJsonEventCopyWithImpl<$Res, MainDataJsonEvent>;
  @useResult
  $Res call({SiteType siteType});
}

/// @nodoc
class _$MainDataJsonEventCopyWithImpl<$Res, $Val extends MainDataJsonEvent>
    implements $MainDataJsonEventCopyWith<$Res> {
  _$MainDataJsonEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainDataJsonEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
  }) {
    return _then(_value.copyWith(
      siteType: null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetListEventImplCopyWith<$Res>
    implements $MainDataJsonEventCopyWith<$Res> {
  factory _$$GetListEventImplCopyWith(
          _$GetListEventImpl value, $Res Function(_$GetListEventImpl) then) =
      __$$GetListEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SiteType siteType});
}

/// @nodoc
class __$$GetListEventImplCopyWithImpl<$Res>
    extends _$MainDataJsonEventCopyWithImpl<$Res, _$GetListEventImpl>
    implements _$$GetListEventImplCopyWith<$Res> {
  __$$GetListEventImplCopyWithImpl(
      _$GetListEventImpl _value, $Res Function(_$GetListEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataJsonEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
  }) {
    return _then(_$GetListEventImpl(
      siteType: null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
    ));
  }
}

/// @nodoc

class _$GetListEventImpl implements GetListEvent {
  const _$GetListEventImpl({required this.siteType});

  @override
  final SiteType siteType;

  @override
  String toString() {
    return 'MainDataJsonEvent.getList(siteType: $siteType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetListEventImpl &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, siteType);

  /// Create a copy of MainDataJsonEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetListEventImplCopyWith<_$GetListEventImpl> get copyWith =>
      __$$GetListEventImplCopyWithImpl<_$GetListEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SiteType siteType) getList,
    required TResult Function(SiteType siteType, List<MainItem> list) addList,
  }) {
    return getList(siteType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SiteType siteType)? getList,
    TResult? Function(SiteType siteType, List<MainItem> list)? addList,
  }) {
    return getList?.call(siteType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SiteType siteType)? getList,
    TResult Function(SiteType siteType, List<MainItem> list)? addList,
    required TResult orElse(),
  }) {
    if (getList != null) {
      return getList(siteType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetListEvent value) getList,
    required TResult Function(AddListEvent value) addList,
  }) {
    return getList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetListEvent value)? getList,
    TResult? Function(AddListEvent value)? addList,
  }) {
    return getList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetListEvent value)? getList,
    TResult Function(AddListEvent value)? addList,
    required TResult orElse(),
  }) {
    if (getList != null) {
      return getList(this);
    }
    return orElse();
  }
}

abstract class GetListEvent implements MainDataJsonEvent {
  const factory GetListEvent({required final SiteType siteType}) =
      _$GetListEventImpl;

  @override
  SiteType get siteType;

  /// Create a copy of MainDataJsonEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetListEventImplCopyWith<_$GetListEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddListEventImplCopyWith<$Res>
    implements $MainDataJsonEventCopyWith<$Res> {
  factory _$$AddListEventImplCopyWith(
          _$AddListEventImpl value, $Res Function(_$AddListEventImpl) then) =
      __$$AddListEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SiteType siteType, List<MainItem> list});
}

/// @nodoc
class __$$AddListEventImplCopyWithImpl<$Res>
    extends _$MainDataJsonEventCopyWithImpl<$Res, _$AddListEventImpl>
    implements _$$AddListEventImplCopyWith<$Res> {
  __$$AddListEventImplCopyWithImpl(
      _$AddListEventImpl _value, $Res Function(_$AddListEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataJsonEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
    Object? list = null,
  }) {
    return _then(_$AddListEventImpl(
      siteType: null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<MainItem>,
    ));
  }
}

/// @nodoc

class _$AddListEventImpl implements AddListEvent {
  const _$AddListEventImpl(
      {required this.siteType, required final List<MainItem> list})
      : _list = list;

  @override
  final SiteType siteType;
  final List<MainItem> _list;
  @override
  List<MainItem> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'MainDataJsonEvent.addList(siteType: $siteType, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddListEventImpl &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, siteType, const DeepCollectionEquality().hash(_list));

  /// Create a copy of MainDataJsonEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddListEventImplCopyWith<_$AddListEventImpl> get copyWith =>
      __$$AddListEventImplCopyWithImpl<_$AddListEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SiteType siteType) getList,
    required TResult Function(SiteType siteType, List<MainItem> list) addList,
  }) {
    return addList(siteType, list);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SiteType siteType)? getList,
    TResult? Function(SiteType siteType, List<MainItem> list)? addList,
  }) {
    return addList?.call(siteType, list);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SiteType siteType)? getList,
    TResult Function(SiteType siteType, List<MainItem> list)? addList,
    required TResult orElse(),
  }) {
    if (addList != null) {
      return addList(siteType, list);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetListEvent value) getList,
    required TResult Function(AddListEvent value) addList,
  }) {
    return addList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetListEvent value)? getList,
    TResult? Function(AddListEvent value)? addList,
  }) {
    return addList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetListEvent value)? getList,
    TResult Function(AddListEvent value)? addList,
    required TResult orElse(),
  }) {
    if (addList != null) {
      return addList(this);
    }
    return orElse();
  }
}

abstract class AddListEvent implements MainDataJsonEvent {
  const factory AddListEvent(
      {required final SiteType siteType,
      required final List<MainItem> list}) = _$AddListEventImpl;

  @override
  SiteType get siteType;
  List<MainItem> get list;

  /// Create a copy of MainDataJsonEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddListEventImplCopyWith<_$AddListEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MainDataJsonState {
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
    required TResult Function(StateInitial value) initial,
    required TResult Function(StateLoading value) loading,
    required TResult Function(StateSuccess value) success,
    required TResult Function(StateFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial value)? initial,
    TResult? Function(StateLoading value)? loading,
    TResult? Function(StateSuccess value)? success,
    TResult? Function(StateFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial value)? initial,
    TResult Function(StateLoading value)? loading,
    TResult Function(StateSuccess value)? success,
    TResult Function(StateFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainDataJsonStateCopyWith<$Res> {
  factory $MainDataJsonStateCopyWith(
          MainDataJsonState value, $Res Function(MainDataJsonState) then) =
      _$MainDataJsonStateCopyWithImpl<$Res, MainDataJsonState>;
}

/// @nodoc
class _$MainDataJsonStateCopyWithImpl<$Res, $Val extends MainDataJsonState>
    implements $MainDataJsonStateCopyWith<$Res> {
  _$MainDataJsonStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainDataJsonState
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
    extends _$MainDataJsonStateCopyWithImpl<$Res, _$StateInitialImpl>
    implements _$$StateInitialImplCopyWith<$Res> {
  __$$StateInitialImplCopyWithImpl(
      _$StateInitialImpl _value, $Res Function(_$StateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataJsonState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StateInitialImpl implements StateInitial {
  const _$StateInitialImpl();

  @override
  String toString() {
    return 'MainDataJsonState.initial()';
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
    required TResult Function(StateInitial value) initial,
    required TResult Function(StateLoading value) loading,
    required TResult Function(StateSuccess value) success,
    required TResult Function(StateFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial value)? initial,
    TResult? Function(StateLoading value)? loading,
    TResult? Function(StateSuccess value)? success,
    TResult? Function(StateFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial value)? initial,
    TResult Function(StateLoading value)? loading,
    TResult Function(StateSuccess value)? success,
    TResult Function(StateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class StateInitial implements MainDataJsonState {
  const factory StateInitial() = _$StateInitialImpl;
}

/// @nodoc
abstract class _$$StateLoadingImplCopyWith<$Res> {
  factory _$$StateLoadingImplCopyWith(
          _$StateLoadingImpl value, $Res Function(_$StateLoadingImpl) then) =
      __$$StateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StateLoadingImplCopyWithImpl<$Res>
    extends _$MainDataJsonStateCopyWithImpl<$Res, _$StateLoadingImpl>
    implements _$$StateLoadingImplCopyWith<$Res> {
  __$$StateLoadingImplCopyWithImpl(
      _$StateLoadingImpl _value, $Res Function(_$StateLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataJsonState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StateLoadingImpl implements StateLoading {
  const _$StateLoadingImpl();

  @override
  String toString() {
    return 'MainDataJsonState.loading()';
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
    required TResult Function(StateInitial value) initial,
    required TResult Function(StateLoading value) loading,
    required TResult Function(StateSuccess value) success,
    required TResult Function(StateFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial value)? initial,
    TResult? Function(StateLoading value)? loading,
    TResult? Function(StateSuccess value)? success,
    TResult? Function(StateFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial value)? initial,
    TResult Function(StateLoading value)? loading,
    TResult Function(StateSuccess value)? success,
    TResult Function(StateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class StateLoading implements MainDataJsonState {
  const factory StateLoading() = _$StateLoadingImpl;
}

/// @nodoc
abstract class _$$StateSuccessImplCopyWith<$Res> {
  factory _$$StateSuccessImplCopyWith(
          _$StateSuccessImpl value, $Res Function(_$StateSuccessImpl) then) =
      __$$StateSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<MainItem> data});
}

/// @nodoc
class __$$StateSuccessImplCopyWithImpl<$Res>
    extends _$MainDataJsonStateCopyWithImpl<$Res, _$StateSuccessImpl>
    implements _$$StateSuccessImplCopyWith<$Res> {
  __$$StateSuccessImplCopyWithImpl(
      _$StateSuccessImpl _value, $Res Function(_$StateSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataJsonState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$StateSuccessImpl(
      null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MainItem>,
    ));
  }
}

/// @nodoc

class _$StateSuccessImpl implements StateSuccess {
  const _$StateSuccessImpl(final List<MainItem> data) : _data = data;

  final List<MainItem> _data;
  @override
  List<MainItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'MainDataJsonState.success(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateSuccessImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of MainDataJsonState
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
    required TResult Function(StateInitial value) initial,
    required TResult Function(StateLoading value) loading,
    required TResult Function(StateSuccess value) success,
    required TResult Function(StateFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial value)? initial,
    TResult? Function(StateLoading value)? loading,
    TResult? Function(StateSuccess value)? success,
    TResult? Function(StateFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial value)? initial,
    TResult Function(StateLoading value)? loading,
    TResult Function(StateSuccess value)? success,
    TResult Function(StateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class StateSuccess implements MainDataJsonState {
  const factory StateSuccess(final List<MainItem> data) = _$StateSuccessImpl;

  List<MainItem> get data;

  /// Create a copy of MainDataJsonState
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
    extends _$MainDataJsonStateCopyWithImpl<$Res, _$StateFailureImpl>
    implements _$$StateFailureImplCopyWith<$Res> {
  __$$StateFailureImplCopyWithImpl(
      _$StateFailureImpl _value, $Res Function(_$StateFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataJsonState
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

class _$StateFailureImpl implements StateFailure {
  const _$StateFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MainDataJsonState.failure(message: $message)';
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

  /// Create a copy of MainDataJsonState
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
    required TResult Function(StateInitial value) initial,
    required TResult Function(StateLoading value) loading,
    required TResult Function(StateSuccess value) success,
    required TResult Function(StateFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial value)? initial,
    TResult? Function(StateLoading value)? loading,
    TResult? Function(StateSuccess value)? success,
    TResult? Function(StateFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial value)? initial,
    TResult Function(StateLoading value)? loading,
    TResult Function(StateSuccess value)? success,
    TResult Function(StateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class StateFailure implements MainDataJsonState {
  const factory StateFailure(final String message) = _$StateFailureImpl;

  String get message;

  /// Create a copy of MainDataJsonState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateFailureImplCopyWith<_$StateFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
