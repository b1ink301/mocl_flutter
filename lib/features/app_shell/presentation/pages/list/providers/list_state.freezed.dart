// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListState {

 List<ListItem> get items; bool get isLoading; int get currentPage; LastId get lastId; bool get hasReachedMax; String? get error;
/// Create a copy of ListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListStateCopyWith<ListState> get copyWith => _$ListStateCopyWithImpl<ListState>(this as ListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastId, lastId) || other.lastId == lastId)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),isLoading,currentPage,lastId,hasReachedMax,error);

@override
String toString() {
  return 'ListState(items: $items, isLoading: $isLoading, currentPage: $currentPage, lastId: $lastId, hasReachedMax: $hasReachedMax, error: $error)';
}


}

/// @nodoc
abstract mixin class $ListStateCopyWith<$Res>  {
  factory $ListStateCopyWith(ListState value, $Res Function(ListState) _then) = _$ListStateCopyWithImpl;
@useResult
$Res call({
 List<ListItem> items, bool isLoading, int currentPage, LastId lastId, bool hasReachedMax, String? error
});


$LastIdCopyWith<$Res> get lastId;

}
/// @nodoc
class _$ListStateCopyWithImpl<$Res>
    implements $ListStateCopyWith<$Res> {
  _$ListStateCopyWithImpl(this._self, this._then);

  final ListState _self;
  final $Res Function(ListState) _then;

/// Create a copy of ListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? isLoading = null,Object? currentPage = null,Object? lastId = null,Object? hasReachedMax = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ListItem>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as LastId,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastIdCopyWith<$Res> get lastId {
  
  return $LastIdCopyWith<$Res>(_self.lastId, (value) {
    return _then(_self.copyWith(lastId: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListState].
extension ListStatePatterns on ListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListState value)  $default,){
final _that = this;
switch (_that) {
case _ListState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListState value)?  $default,){
final _that = this;
switch (_that) {
case _ListState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ListItem> items,  bool isLoading,  int currentPage,  LastId lastId,  bool hasReachedMax,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListState() when $default != null:
return $default(_that.items,_that.isLoading,_that.currentPage,_that.lastId,_that.hasReachedMax,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ListItem> items,  bool isLoading,  int currentPage,  LastId lastId,  bool hasReachedMax,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ListState():
return $default(_that.items,_that.isLoading,_that.currentPage,_that.lastId,_that.hasReachedMax,_that.error);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ListItem> items,  bool isLoading,  int currentPage,  LastId lastId,  bool hasReachedMax,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ListState() when $default != null:
return $default(_that.items,_that.isLoading,_that.currentPage,_that.lastId,_that.hasReachedMax,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ListState implements ListState {
  const _ListState({required final  List<ListItem> items, required this.isLoading, required this.currentPage, required this.lastId, this.hasReachedMax = false, this.error}): _items = items;
  

 final  List<ListItem> _items;
@override List<ListItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool isLoading;
@override final  int currentPage;
@override final  LastId lastId;
@override@JsonKey() final  bool hasReachedMax;
@override final  String? error;

/// Create a copy of ListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListStateCopyWith<_ListState> get copyWith => __$ListStateCopyWithImpl<_ListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastId, lastId) || other.lastId == lastId)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isLoading,currentPage,lastId,hasReachedMax,error);

@override
String toString() {
  return 'ListState(items: $items, isLoading: $isLoading, currentPage: $currentPage, lastId: $lastId, hasReachedMax: $hasReachedMax, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ListStateCopyWith<$Res> implements $ListStateCopyWith<$Res> {
  factory _$ListStateCopyWith(_ListState value, $Res Function(_ListState) _then) = __$ListStateCopyWithImpl;
@override @useResult
$Res call({
 List<ListItem> items, bool isLoading, int currentPage, LastId lastId, bool hasReachedMax, String? error
});


@override $LastIdCopyWith<$Res> get lastId;

}
/// @nodoc
class __$ListStateCopyWithImpl<$Res>
    implements _$ListStateCopyWith<$Res> {
  __$ListStateCopyWithImpl(this._self, this._then);

  final _ListState _self;
  final $Res Function(_ListState) _then;

/// Create a copy of ListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isLoading = null,Object? currentPage = null,Object? lastId = null,Object? hasReachedMax = null,Object? error = freezed,}) {
  return _then(_ListState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ListItem>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as LastId,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastIdCopyWith<$Res> get lastId {
  
  return $LastIdCopyWith<$Res>(_self.lastId, (value) {
    return _then(_self.copyWith(lastId: value));
  });
}
}

// dart format on
