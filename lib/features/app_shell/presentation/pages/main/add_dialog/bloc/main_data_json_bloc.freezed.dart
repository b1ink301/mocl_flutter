// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_data_json_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MainDataJsonEvent {

 SiteType get siteType;
/// Create a copy of MainDataJsonEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainDataJsonEventCopyWith<MainDataJsonEvent> get copyWith => _$MainDataJsonEventCopyWithImpl<MainDataJsonEvent>(this as MainDataJsonEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainDataJsonEvent&&(identical(other.siteType, siteType) || other.siteType == siteType));
}


@override
int get hashCode => Object.hash(runtimeType,siteType);

@override
String toString() {
  return 'MainDataJsonEvent(siteType: $siteType)';
}


}

/// @nodoc
abstract mixin class $MainDataJsonEventCopyWith<$Res>  {
  factory $MainDataJsonEventCopyWith(MainDataJsonEvent value, $Res Function(MainDataJsonEvent) _then) = _$MainDataJsonEventCopyWithImpl;
@useResult
$Res call({
 SiteType siteType
});




}
/// @nodoc
class _$MainDataJsonEventCopyWithImpl<$Res>
    implements $MainDataJsonEventCopyWith<$Res> {
  _$MainDataJsonEventCopyWithImpl(this._self, this._then);

  final MainDataJsonEvent _self;
  final $Res Function(MainDataJsonEvent) _then;

/// Create a copy of MainDataJsonEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? siteType = null,}) {
  return _then(_self.copyWith(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,
  ));
}

}


/// Adds pattern-matching-related methods to [MainDataJsonEvent].
extension MainDataJsonEventPatterns on MainDataJsonEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GetListEvent value)?  getList,TResult Function( AddListEvent value)?  addList,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GetListEvent() when getList != null:
return getList(_that);case AddListEvent() when addList != null:
return addList(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GetListEvent value)  getList,required TResult Function( AddListEvent value)  addList,}){
final _that = this;
switch (_that) {
case GetListEvent():
return getList(_that);case AddListEvent():
return addList(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GetListEvent value)?  getList,TResult? Function( AddListEvent value)?  addList,}){
final _that = this;
switch (_that) {
case GetListEvent() when getList != null:
return getList(_that);case AddListEvent() when addList != null:
return addList(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SiteType siteType)?  getList,TResult Function( SiteType siteType,  List<MainItem> list)?  addList,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GetListEvent() when getList != null:
return getList(_that.siteType);case AddListEvent() when addList != null:
return addList(_that.siteType,_that.list);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SiteType siteType)  getList,required TResult Function( SiteType siteType,  List<MainItem> list)  addList,}) {final _that = this;
switch (_that) {
case GetListEvent():
return getList(_that.siteType);case AddListEvent():
return addList(_that.siteType,_that.list);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SiteType siteType)?  getList,TResult? Function( SiteType siteType,  List<MainItem> list)?  addList,}) {final _that = this;
switch (_that) {
case GetListEvent() when getList != null:
return getList(_that.siteType);case AddListEvent() when addList != null:
return addList(_that.siteType,_that.list);case _:
  return null;

}
}

}

/// @nodoc


class GetListEvent implements MainDataJsonEvent {
  const GetListEvent({required this.siteType});
  

@override final  SiteType siteType;

/// Create a copy of MainDataJsonEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetListEventCopyWith<GetListEvent> get copyWith => _$GetListEventCopyWithImpl<GetListEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetListEvent&&(identical(other.siteType, siteType) || other.siteType == siteType));
}


@override
int get hashCode => Object.hash(runtimeType,siteType);

@override
String toString() {
  return 'MainDataJsonEvent.getList(siteType: $siteType)';
}


}

/// @nodoc
abstract mixin class $GetListEventCopyWith<$Res> implements $MainDataJsonEventCopyWith<$Res> {
  factory $GetListEventCopyWith(GetListEvent value, $Res Function(GetListEvent) _then) = _$GetListEventCopyWithImpl;
@override @useResult
$Res call({
 SiteType siteType
});




}
/// @nodoc
class _$GetListEventCopyWithImpl<$Res>
    implements $GetListEventCopyWith<$Res> {
  _$GetListEventCopyWithImpl(this._self, this._then);

  final GetListEvent _self;
  final $Res Function(GetListEvent) _then;

/// Create a copy of MainDataJsonEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteType = null,}) {
  return _then(GetListEvent(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,
  ));
}


}

/// @nodoc


class AddListEvent implements MainDataJsonEvent {
  const AddListEvent({required this.siteType, required final  List<MainItem> list}): _list = list;
  

@override final  SiteType siteType;
 final  List<MainItem> _list;
 List<MainItem> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}


/// Create a copy of MainDataJsonEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddListEventCopyWith<AddListEvent> get copyWith => _$AddListEventCopyWithImpl<AddListEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddListEvent&&(identical(other.siteType, siteType) || other.siteType == siteType)&&const DeepCollectionEquality().equals(other._list, _list));
}


@override
int get hashCode => Object.hash(runtimeType,siteType,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'MainDataJsonEvent.addList(siteType: $siteType, list: $list)';
}


}

/// @nodoc
abstract mixin class $AddListEventCopyWith<$Res> implements $MainDataJsonEventCopyWith<$Res> {
  factory $AddListEventCopyWith(AddListEvent value, $Res Function(AddListEvent) _then) = _$AddListEventCopyWithImpl;
@override @useResult
$Res call({
 SiteType siteType, List<MainItem> list
});




}
/// @nodoc
class _$AddListEventCopyWithImpl<$Res>
    implements $AddListEventCopyWith<$Res> {
  _$AddListEventCopyWithImpl(this._self, this._then);

  final AddListEvent _self;
  final $Res Function(AddListEvent) _then;

/// Create a copy of MainDataJsonEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteType = null,Object? list = null,}) {
  return _then(AddListEvent(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<MainItem>,
  ));
}


}

/// @nodoc
mixin _$MainDataJsonState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainDataJsonState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MainDataJsonState()';
}


}

/// @nodoc
class $MainDataJsonStateCopyWith<$Res>  {
$MainDataJsonStateCopyWith(MainDataJsonState _, $Res Function(MainDataJsonState) __);
}


/// Adds pattern-matching-related methods to [MainDataJsonState].
extension MainDataJsonStatePatterns on MainDataJsonState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StateInitial value)?  initial,TResult Function( StateLoading value)?  loading,TResult Function( StateSuccess value)?  success,TResult Function( StateFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StateInitial() when initial != null:
return initial(_that);case StateLoading() when loading != null:
return loading(_that);case StateSuccess() when success != null:
return success(_that);case StateFailure() when failure != null:
return failure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StateInitial value)  initial,required TResult Function( StateLoading value)  loading,required TResult Function( StateSuccess value)  success,required TResult Function( StateFailure value)  failure,}){
final _that = this;
switch (_that) {
case StateInitial():
return initial(_that);case StateLoading():
return loading(_that);case StateSuccess():
return success(_that);case StateFailure():
return failure(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StateInitial value)?  initial,TResult? Function( StateLoading value)?  loading,TResult? Function( StateSuccess value)?  success,TResult? Function( StateFailure value)?  failure,}){
final _that = this;
switch (_that) {
case StateInitial() when initial != null:
return initial(_that);case StateLoading() when loading != null:
return loading(_that);case StateSuccess() when success != null:
return success(_that);case StateFailure() when failure != null:
return failure(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<MainItem> data)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StateInitial() when initial != null:
return initial();case StateLoading() when loading != null:
return loading();case StateSuccess() when success != null:
return success(_that.data);case StateFailure() when failure != null:
return failure(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<MainItem> data)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case StateInitial():
return initial();case StateLoading():
return loading();case StateSuccess():
return success(_that.data);case StateFailure():
return failure(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<MainItem> data)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case StateInitial() when initial != null:
return initial();case StateLoading() when loading != null:
return loading();case StateSuccess() when success != null:
return success(_that.data);case StateFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class StateInitial implements MainDataJsonState {
  const StateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MainDataJsonState.initial()';
}


}




/// @nodoc


class StateLoading implements MainDataJsonState {
  const StateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MainDataJsonState.loading()';
}


}




/// @nodoc


class StateSuccess implements MainDataJsonState {
  const StateSuccess(final  List<MainItem> data): _data = data;
  

 final  List<MainItem> _data;
 List<MainItem> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of MainDataJsonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StateSuccessCopyWith<StateSuccess> get copyWith => _$StateSuccessCopyWithImpl<StateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StateSuccess&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'MainDataJsonState.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $StateSuccessCopyWith<$Res> implements $MainDataJsonStateCopyWith<$Res> {
  factory $StateSuccessCopyWith(StateSuccess value, $Res Function(StateSuccess) _then) = _$StateSuccessCopyWithImpl;
@useResult
$Res call({
 List<MainItem> data
});




}
/// @nodoc
class _$StateSuccessCopyWithImpl<$Res>
    implements $StateSuccessCopyWith<$Res> {
  _$StateSuccessCopyWithImpl(this._self, this._then);

  final StateSuccess _self;
  final $Res Function(StateSuccess) _then;

/// Create a copy of MainDataJsonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(StateSuccess(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<MainItem>,
  ));
}


}

/// @nodoc


class StateFailure implements MainDataJsonState {
  const StateFailure(this.message);
  

 final  String message;

/// Create a copy of MainDataJsonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StateFailureCopyWith<StateFailure> get copyWith => _$StateFailureCopyWithImpl<StateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StateFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MainDataJsonState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $StateFailureCopyWith<$Res> implements $MainDataJsonStateCopyWith<$Res> {
  factory $StateFailureCopyWith(StateFailure value, $Res Function(StateFailure) _then) = _$StateFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$StateFailureCopyWithImpl<$Res>
    implements $StateFailureCopyWith<$Res> {
  _$StateFailureCopyWithImpl(this._self, this._then);

  final StateFailure _self;
  final $Res Function(StateFailure) _then;

/// Create a copy of MainDataJsonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(StateFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
