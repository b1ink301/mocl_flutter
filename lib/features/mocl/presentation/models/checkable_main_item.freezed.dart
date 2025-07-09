// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkable_main_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckableMainItem {

 MainItem get mainItem; bool get isChecked;
/// Create a copy of CheckableMainItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckableMainItemCopyWith<CheckableMainItem> get copyWith => _$CheckableMainItemCopyWithImpl<CheckableMainItem>(this as CheckableMainItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckableMainItem&&(identical(other.mainItem, mainItem) || other.mainItem == mainItem)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked));
}


@override
int get hashCode => Object.hash(runtimeType,mainItem,isChecked);

@override
String toString() {
  return 'CheckableMainItem(mainItem: $mainItem, isChecked: $isChecked)';
}


}

/// @nodoc
abstract mixin class $CheckableMainItemCopyWith<$Res>  {
  factory $CheckableMainItemCopyWith(CheckableMainItem value, $Res Function(CheckableMainItem) _then) = _$CheckableMainItemCopyWithImpl;
@useResult
$Res call({
 MainItem mainItem, bool isChecked
});


$MainItemCopyWith<$Res> get mainItem;

}
/// @nodoc
class _$CheckableMainItemCopyWithImpl<$Res>
    implements $CheckableMainItemCopyWith<$Res> {
  _$CheckableMainItemCopyWithImpl(this._self, this._then);

  final CheckableMainItem _self;
  final $Res Function(CheckableMainItem) _then;

/// Create a copy of CheckableMainItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mainItem = null,Object? isChecked = null,}) {
  return _then(_self.copyWith(
mainItem: null == mainItem ? _self.mainItem : mainItem // ignore: cast_nullable_to_non_nullable
as MainItem,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CheckableMainItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainItemCopyWith<$Res> get mainItem {
  
  return $MainItemCopyWith<$Res>(_self.mainItem, (value) {
    return _then(_self.copyWith(mainItem: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckableMainItem].
extension CheckableMainItemPatterns on CheckableMainItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckableMainItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckableMainItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckableMainItem value)  $default,){
final _that = this;
switch (_that) {
case _CheckableMainItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckableMainItem value)?  $default,){
final _that = this;
switch (_that) {
case _CheckableMainItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MainItem mainItem,  bool isChecked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckableMainItem() when $default != null:
return $default(_that.mainItem,_that.isChecked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MainItem mainItem,  bool isChecked)  $default,) {final _that = this;
switch (_that) {
case _CheckableMainItem():
return $default(_that.mainItem,_that.isChecked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MainItem mainItem,  bool isChecked)?  $default,) {final _that = this;
switch (_that) {
case _CheckableMainItem() when $default != null:
return $default(_that.mainItem,_that.isChecked);case _:
  return null;

}
}

}

/// @nodoc


class _CheckableMainItem implements CheckableMainItem {
   _CheckableMainItem({required this.mainItem, required this.isChecked});
  

@override final  MainItem mainItem;
@override final  bool isChecked;

/// Create a copy of CheckableMainItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckableMainItemCopyWith<_CheckableMainItem> get copyWith => __$CheckableMainItemCopyWithImpl<_CheckableMainItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckableMainItem&&(identical(other.mainItem, mainItem) || other.mainItem == mainItem)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked));
}


@override
int get hashCode => Object.hash(runtimeType,mainItem,isChecked);

@override
String toString() {
  return 'CheckableMainItem(mainItem: $mainItem, isChecked: $isChecked)';
}


}

/// @nodoc
abstract mixin class _$CheckableMainItemCopyWith<$Res> implements $CheckableMainItemCopyWith<$Res> {
  factory _$CheckableMainItemCopyWith(_CheckableMainItem value, $Res Function(_CheckableMainItem) _then) = __$CheckableMainItemCopyWithImpl;
@override @useResult
$Res call({
 MainItem mainItem, bool isChecked
});


@override $MainItemCopyWith<$Res> get mainItem;

}
/// @nodoc
class __$CheckableMainItemCopyWithImpl<$Res>
    implements _$CheckableMainItemCopyWith<$Res> {
  __$CheckableMainItemCopyWithImpl(this._self, this._then);

  final _CheckableMainItem _self;
  final $Res Function(_CheckableMainItem) _then;

/// Create a copy of CheckableMainItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mainItem = null,Object? isChecked = null,}) {
  return _then(_CheckableMainItem(
mainItem: null == mainItem ? _self.mainItem : mainItem // ignore: cast_nullable_to_non_nullable
as MainItem,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CheckableMainItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainItemCopyWith<$Res> get mainItem {
  
  return $MainItemCopyWith<$Res>(_self.mainItem, (value) {
    return _then(_self.copyWith(mainItem: value));
  });
}
}

// dart format on
