// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_data_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MainDataEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SiteType siteType) getList,
    required TResult Function(SiteType siteType) setSiteType,
    required TResult Function() getSiteType,
    required TResult Function(SiteType siteType, List<MainItem> list) setList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SiteType siteType)? getList,
    TResult? Function(SiteType siteType)? setSiteType,
    TResult? Function()? getSiteType,
    TResult? Function(SiteType siteType, List<MainItem> list)? setList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SiteType siteType)? getList,
    TResult Function(SiteType siteType)? setSiteType,
    TResult Function()? getSiteType,
    TResult Function(SiteType siteType, List<MainItem> list)? setList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetListEvent value) getList,
    required TResult Function(SetSiteTypeEvent value) setSiteType,
    required TResult Function(GetSiteTypeEvent value) getSiteType,
    required TResult Function(SetListEvent value) setList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetListEvent value)? getList,
    TResult? Function(SetSiteTypeEvent value)? setSiteType,
    TResult? Function(GetSiteTypeEvent value)? getSiteType,
    TResult? Function(SetListEvent value)? setList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetListEvent value)? getList,
    TResult Function(SetSiteTypeEvent value)? setSiteType,
    TResult Function(GetSiteTypeEvent value)? getSiteType,
    TResult Function(SetListEvent value)? setList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainDataEventCopyWith<$Res> {
  factory $MainDataEventCopyWith(
          MainDataEvent value, $Res Function(MainDataEvent) then) =
      _$MainDataEventCopyWithImpl<$Res, MainDataEvent>;
}

/// @nodoc
class _$MainDataEventCopyWithImpl<$Res, $Val extends MainDataEvent>
    implements $MainDataEventCopyWith<$Res> {
  _$MainDataEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetListEventImplCopyWith<$Res> {
  factory _$$GetListEventImplCopyWith(
          _$GetListEventImpl value, $Res Function(_$GetListEventImpl) then) =
      __$$GetListEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SiteType siteType});
}

/// @nodoc
class __$$GetListEventImplCopyWithImpl<$Res>
    extends _$MainDataEventCopyWithImpl<$Res, _$GetListEventImpl>
    implements _$$GetListEventImplCopyWith<$Res> {
  __$$GetListEventImplCopyWithImpl(
      _$GetListEventImpl _value, $Res Function(_$GetListEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataEvent
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
    return 'MainDataEvent.getList(siteType: $siteType)';
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

  /// Create a copy of MainDataEvent
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
    required TResult Function(SiteType siteType) setSiteType,
    required TResult Function() getSiteType,
    required TResult Function(SiteType siteType, List<MainItem> list) setList,
  }) {
    return getList(siteType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SiteType siteType)? getList,
    TResult? Function(SiteType siteType)? setSiteType,
    TResult? Function()? getSiteType,
    TResult? Function(SiteType siteType, List<MainItem> list)? setList,
  }) {
    return getList?.call(siteType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SiteType siteType)? getList,
    TResult Function(SiteType siteType)? setSiteType,
    TResult Function()? getSiteType,
    TResult Function(SiteType siteType, List<MainItem> list)? setList,
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
    required TResult Function(SetSiteTypeEvent value) setSiteType,
    required TResult Function(GetSiteTypeEvent value) getSiteType,
    required TResult Function(SetListEvent value) setList,
  }) {
    return getList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetListEvent value)? getList,
    TResult? Function(SetSiteTypeEvent value)? setSiteType,
    TResult? Function(GetSiteTypeEvent value)? getSiteType,
    TResult? Function(SetListEvent value)? setList,
  }) {
    return getList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetListEvent value)? getList,
    TResult Function(SetSiteTypeEvent value)? setSiteType,
    TResult Function(GetSiteTypeEvent value)? getSiteType,
    TResult Function(SetListEvent value)? setList,
    required TResult orElse(),
  }) {
    if (getList != null) {
      return getList(this);
    }
    return orElse();
  }
}

abstract class GetListEvent implements MainDataEvent {
  const factory GetListEvent({required final SiteType siteType}) =
      _$GetListEventImpl;

  SiteType get siteType;

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetListEventImplCopyWith<_$GetListEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SetSiteTypeEventImplCopyWith<$Res> {
  factory _$$SetSiteTypeEventImplCopyWith(_$SetSiteTypeEventImpl value,
          $Res Function(_$SetSiteTypeEventImpl) then) =
      __$$SetSiteTypeEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SiteType siteType});
}

/// @nodoc
class __$$SetSiteTypeEventImplCopyWithImpl<$Res>
    extends _$MainDataEventCopyWithImpl<$Res, _$SetSiteTypeEventImpl>
    implements _$$SetSiteTypeEventImplCopyWith<$Res> {
  __$$SetSiteTypeEventImplCopyWithImpl(_$SetSiteTypeEventImpl _value,
      $Res Function(_$SetSiteTypeEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
  }) {
    return _then(_$SetSiteTypeEventImpl(
      siteType: null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
    ));
  }
}

/// @nodoc

class _$SetSiteTypeEventImpl implements SetSiteTypeEvent {
  const _$SetSiteTypeEventImpl({required this.siteType});

  @override
  final SiteType siteType;

  @override
  String toString() {
    return 'MainDataEvent.setSiteType(siteType: $siteType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetSiteTypeEventImpl &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, siteType);

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetSiteTypeEventImplCopyWith<_$SetSiteTypeEventImpl> get copyWith =>
      __$$SetSiteTypeEventImplCopyWithImpl<_$SetSiteTypeEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SiteType siteType) getList,
    required TResult Function(SiteType siteType) setSiteType,
    required TResult Function() getSiteType,
    required TResult Function(SiteType siteType, List<MainItem> list) setList,
  }) {
    return setSiteType(siteType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SiteType siteType)? getList,
    TResult? Function(SiteType siteType)? setSiteType,
    TResult? Function()? getSiteType,
    TResult? Function(SiteType siteType, List<MainItem> list)? setList,
  }) {
    return setSiteType?.call(siteType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SiteType siteType)? getList,
    TResult Function(SiteType siteType)? setSiteType,
    TResult Function()? getSiteType,
    TResult Function(SiteType siteType, List<MainItem> list)? setList,
    required TResult orElse(),
  }) {
    if (setSiteType != null) {
      return setSiteType(siteType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetListEvent value) getList,
    required TResult Function(SetSiteTypeEvent value) setSiteType,
    required TResult Function(GetSiteTypeEvent value) getSiteType,
    required TResult Function(SetListEvent value) setList,
  }) {
    return setSiteType(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetListEvent value)? getList,
    TResult? Function(SetSiteTypeEvent value)? setSiteType,
    TResult? Function(GetSiteTypeEvent value)? getSiteType,
    TResult? Function(SetListEvent value)? setList,
  }) {
    return setSiteType?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetListEvent value)? getList,
    TResult Function(SetSiteTypeEvent value)? setSiteType,
    TResult Function(GetSiteTypeEvent value)? getSiteType,
    TResult Function(SetListEvent value)? setList,
    required TResult orElse(),
  }) {
    if (setSiteType != null) {
      return setSiteType(this);
    }
    return orElse();
  }
}

abstract class SetSiteTypeEvent implements MainDataEvent {
  const factory SetSiteTypeEvent({required final SiteType siteType}) =
      _$SetSiteTypeEventImpl;

  SiteType get siteType;

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetSiteTypeEventImplCopyWith<_$SetSiteTypeEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetSiteTypeEventImplCopyWith<$Res> {
  factory _$$GetSiteTypeEventImplCopyWith(_$GetSiteTypeEventImpl value,
          $Res Function(_$GetSiteTypeEventImpl) then) =
      __$$GetSiteTypeEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetSiteTypeEventImplCopyWithImpl<$Res>
    extends _$MainDataEventCopyWithImpl<$Res, _$GetSiteTypeEventImpl>
    implements _$$GetSiteTypeEventImplCopyWith<$Res> {
  __$$GetSiteTypeEventImplCopyWithImpl(_$GetSiteTypeEventImpl _value,
      $Res Function(_$GetSiteTypeEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetSiteTypeEventImpl implements GetSiteTypeEvent {
  const _$GetSiteTypeEventImpl();

  @override
  String toString() {
    return 'MainDataEvent.getSiteType()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetSiteTypeEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SiteType siteType) getList,
    required TResult Function(SiteType siteType) setSiteType,
    required TResult Function() getSiteType,
    required TResult Function(SiteType siteType, List<MainItem> list) setList,
  }) {
    return getSiteType();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SiteType siteType)? getList,
    TResult? Function(SiteType siteType)? setSiteType,
    TResult? Function()? getSiteType,
    TResult? Function(SiteType siteType, List<MainItem> list)? setList,
  }) {
    return getSiteType?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SiteType siteType)? getList,
    TResult Function(SiteType siteType)? setSiteType,
    TResult Function()? getSiteType,
    TResult Function(SiteType siteType, List<MainItem> list)? setList,
    required TResult orElse(),
  }) {
    if (getSiteType != null) {
      return getSiteType();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetListEvent value) getList,
    required TResult Function(SetSiteTypeEvent value) setSiteType,
    required TResult Function(GetSiteTypeEvent value) getSiteType,
    required TResult Function(SetListEvent value) setList,
  }) {
    return getSiteType(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetListEvent value)? getList,
    TResult? Function(SetSiteTypeEvent value)? setSiteType,
    TResult? Function(GetSiteTypeEvent value)? getSiteType,
    TResult? Function(SetListEvent value)? setList,
  }) {
    return getSiteType?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetListEvent value)? getList,
    TResult Function(SetSiteTypeEvent value)? setSiteType,
    TResult Function(GetSiteTypeEvent value)? getSiteType,
    TResult Function(SetListEvent value)? setList,
    required TResult orElse(),
  }) {
    if (getSiteType != null) {
      return getSiteType(this);
    }
    return orElse();
  }
}

abstract class GetSiteTypeEvent implements MainDataEvent {
  const factory GetSiteTypeEvent() = _$GetSiteTypeEventImpl;
}

/// @nodoc
abstract class _$$SetListEventImplCopyWith<$Res> {
  factory _$$SetListEventImplCopyWith(
          _$SetListEventImpl value, $Res Function(_$SetListEventImpl) then) =
      __$$SetListEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SiteType siteType, List<MainItem> list});
}

/// @nodoc
class __$$SetListEventImplCopyWithImpl<$Res>
    extends _$MainDataEventCopyWithImpl<$Res, _$SetListEventImpl>
    implements _$$SetListEventImplCopyWith<$Res> {
  __$$SetListEventImplCopyWithImpl(
      _$SetListEventImpl _value, $Res Function(_$SetListEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siteType = null,
    Object? list = null,
  }) {
    return _then(_$SetListEventImpl(
      null == siteType
          ? _value.siteType
          : siteType // ignore: cast_nullable_to_non_nullable
              as SiteType,
      null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<MainItem>,
    ));
  }
}

/// @nodoc

class _$SetListEventImpl implements SetListEvent {
  const _$SetListEventImpl(this.siteType, final List<MainItem> list)
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
    return 'MainDataEvent.setList(siteType: $siteType, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetListEventImpl &&
            (identical(other.siteType, siteType) ||
                other.siteType == siteType) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, siteType, const DeepCollectionEquality().hash(_list));

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetListEventImplCopyWith<_$SetListEventImpl> get copyWith =>
      __$$SetListEventImplCopyWithImpl<_$SetListEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SiteType siteType) getList,
    required TResult Function(SiteType siteType) setSiteType,
    required TResult Function() getSiteType,
    required TResult Function(SiteType siteType, List<MainItem> list) setList,
  }) {
    return setList(siteType, list);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SiteType siteType)? getList,
    TResult? Function(SiteType siteType)? setSiteType,
    TResult? Function()? getSiteType,
    TResult? Function(SiteType siteType, List<MainItem> list)? setList,
  }) {
    return setList?.call(siteType, list);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SiteType siteType)? getList,
    TResult Function(SiteType siteType)? setSiteType,
    TResult Function()? getSiteType,
    TResult Function(SiteType siteType, List<MainItem> list)? setList,
    required TResult orElse(),
  }) {
    if (setList != null) {
      return setList(siteType, list);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetListEvent value) getList,
    required TResult Function(SetSiteTypeEvent value) setSiteType,
    required TResult Function(GetSiteTypeEvent value) getSiteType,
    required TResult Function(SetListEvent value) setList,
  }) {
    return setList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetListEvent value)? getList,
    TResult? Function(SetSiteTypeEvent value)? setSiteType,
    TResult? Function(GetSiteTypeEvent value)? getSiteType,
    TResult? Function(SetListEvent value)? setList,
  }) {
    return setList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetListEvent value)? getList,
    TResult Function(SetSiteTypeEvent value)? setSiteType,
    TResult Function(GetSiteTypeEvent value)? getSiteType,
    TResult Function(SetListEvent value)? setList,
    required TResult orElse(),
  }) {
    if (setList != null) {
      return setList(this);
    }
    return orElse();
  }
}

abstract class SetListEvent implements MainDataEvent {
  const factory SetListEvent(
      final SiteType siteType, final List<MainItem> list) = _$SetListEventImpl;

  SiteType get siteType;
  List<MainItem> get list;

  /// Create a copy of MainDataEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetListEventImplCopyWith<_$SetListEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MainDataState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data) success,
    required TResult Function(String message) failure,
    required TResult Function(String message) requireLogin,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data)? success,
    TResult? Function(String message)? failure,
    TResult? Function(String message)? requireLogin,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data)? success,
    TResult Function(String message)? failure,
    TResult Function(String message)? requireLogin,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StateInitial value) initial,
    required TResult Function(StateLoading value) loading,
    required TResult Function(StateSuccess value) success,
    required TResult Function(StateFailure value) failure,
    required TResult Function(StateRequireLogin value) requireLogin,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial value)? initial,
    TResult? Function(StateLoading value)? loading,
    TResult? Function(StateSuccess value)? success,
    TResult? Function(StateFailure value)? failure,
    TResult? Function(StateRequireLogin value)? requireLogin,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial value)? initial,
    TResult Function(StateLoading value)? loading,
    TResult Function(StateSuccess value)? success,
    TResult Function(StateFailure value)? failure,
    TResult Function(StateRequireLogin value)? requireLogin,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainDataStateCopyWith<$Res> {
  factory $MainDataStateCopyWith(
          MainDataState value, $Res Function(MainDataState) then) =
      _$MainDataStateCopyWithImpl<$Res, MainDataState>;
}

/// @nodoc
class _$MainDataStateCopyWithImpl<$Res, $Val extends MainDataState>
    implements $MainDataStateCopyWith<$Res> {
  _$MainDataStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MainDataState
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
    extends _$MainDataStateCopyWithImpl<$Res, _$StateInitialImpl>
    implements _$$StateInitialImplCopyWith<$Res> {
  __$$StateInitialImplCopyWithImpl(
      _$StateInitialImpl _value, $Res Function(_$StateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StateInitialImpl implements StateInitial {
  const _$StateInitialImpl();

  @override
  String toString() {
    return 'MainDataState.initial()';
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
    required TResult Function(String message) requireLogin,
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
    TResult? Function(String message)? requireLogin,
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
    TResult Function(String message)? requireLogin,
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
    required TResult Function(StateRequireLogin value) requireLogin,
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
    TResult? Function(StateRequireLogin value)? requireLogin,
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
    TResult Function(StateRequireLogin value)? requireLogin,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class StateInitial implements MainDataState {
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
    extends _$MainDataStateCopyWithImpl<$Res, _$StateLoadingImpl>
    implements _$$StateLoadingImplCopyWith<$Res> {
  __$$StateLoadingImplCopyWithImpl(
      _$StateLoadingImpl _value, $Res Function(_$StateLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StateLoadingImpl implements StateLoading {
  const _$StateLoadingImpl();

  @override
  String toString() {
    return 'MainDataState.loading()';
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
    required TResult Function(String message) requireLogin,
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
    TResult? Function(String message)? requireLogin,
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
    TResult Function(String message)? requireLogin,
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
    required TResult Function(StateRequireLogin value) requireLogin,
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
    TResult? Function(StateRequireLogin value)? requireLogin,
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
    TResult Function(StateRequireLogin value)? requireLogin,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class StateLoading implements MainDataState {
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
    extends _$MainDataStateCopyWithImpl<$Res, _$StateSuccessImpl>
    implements _$$StateSuccessImplCopyWith<$Res> {
  __$$StateSuccessImplCopyWithImpl(
      _$StateSuccessImpl _value, $Res Function(_$StateSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataState
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
    return 'MainDataState.success(data: $data)';
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

  /// Create a copy of MainDataState
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
    required TResult Function(String message) requireLogin,
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
    TResult? Function(String message)? requireLogin,
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
    TResult Function(String message)? requireLogin,
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
    required TResult Function(StateRequireLogin value) requireLogin,
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
    TResult? Function(StateRequireLogin value)? requireLogin,
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
    TResult Function(StateRequireLogin value)? requireLogin,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class StateSuccess implements MainDataState {
  const factory StateSuccess(final List<MainItem> data) = _$StateSuccessImpl;

  List<MainItem> get data;

  /// Create a copy of MainDataState
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
    extends _$MainDataStateCopyWithImpl<$Res, _$StateFailureImpl>
    implements _$$StateFailureImplCopyWith<$Res> {
  __$$StateFailureImplCopyWithImpl(
      _$StateFailureImpl _value, $Res Function(_$StateFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataState
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
    return 'MainDataState.failure(message: $message)';
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

  /// Create a copy of MainDataState
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
    required TResult Function(String message) requireLogin,
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
    TResult? Function(String message)? requireLogin,
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
    TResult Function(String message)? requireLogin,
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
    required TResult Function(StateRequireLogin value) requireLogin,
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
    TResult? Function(StateRequireLogin value)? requireLogin,
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
    TResult Function(StateRequireLogin value)? requireLogin,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class StateFailure implements MainDataState {
  const factory StateFailure(final String message) = _$StateFailureImpl;

  String get message;

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateFailureImplCopyWith<_$StateFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StateRequireLoginImplCopyWith<$Res> {
  factory _$$StateRequireLoginImplCopyWith(_$StateRequireLoginImpl value,
          $Res Function(_$StateRequireLoginImpl) then) =
      __$$StateRequireLoginImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StateRequireLoginImplCopyWithImpl<$Res>
    extends _$MainDataStateCopyWithImpl<$Res, _$StateRequireLoginImpl>
    implements _$$StateRequireLoginImplCopyWith<$Res> {
  __$$StateRequireLoginImplCopyWithImpl(_$StateRequireLoginImpl _value,
      $Res Function(_$StateRequireLoginImpl) _then)
      : super(_value, _then);

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$StateRequireLoginImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StateRequireLoginImpl implements StateRequireLogin {
  const _$StateRequireLoginImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MainDataState.requireLogin(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateRequireLoginImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateRequireLoginImplCopyWith<_$StateRequireLoginImpl> get copyWith =>
      __$$StateRequireLoginImplCopyWithImpl<_$StateRequireLoginImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<MainItem> data) success,
    required TResult Function(String message) failure,
    required TResult Function(String message) requireLogin,
  }) {
    return requireLogin(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<MainItem> data)? success,
    TResult? Function(String message)? failure,
    TResult? Function(String message)? requireLogin,
  }) {
    return requireLogin?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<MainItem> data)? success,
    TResult Function(String message)? failure,
    TResult Function(String message)? requireLogin,
    required TResult orElse(),
  }) {
    if (requireLogin != null) {
      return requireLogin(message);
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
    required TResult Function(StateRequireLogin value) requireLogin,
  }) {
    return requireLogin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StateInitial value)? initial,
    TResult? Function(StateLoading value)? loading,
    TResult? Function(StateSuccess value)? success,
    TResult? Function(StateFailure value)? failure,
    TResult? Function(StateRequireLogin value)? requireLogin,
  }) {
    return requireLogin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StateInitial value)? initial,
    TResult Function(StateLoading value)? loading,
    TResult Function(StateSuccess value)? success,
    TResult Function(StateFailure value)? failure,
    TResult Function(StateRequireLogin value)? requireLogin,
    required TResult orElse(),
  }) {
    if (requireLogin != null) {
      return requireLogin(this);
    }
    return orElse();
  }
}

abstract class StateRequireLogin implements MainDataState {
  const factory StateRequireLogin(final String message) =
      _$StateRequireLoginImpl;

  String get message;

  /// Create a copy of MainDataState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateRequireLoginImplCopyWith<_$StateRequireLoginImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
