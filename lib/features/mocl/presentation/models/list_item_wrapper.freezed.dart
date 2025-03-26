// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_item_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListItemWrapper {

 ListItem get item; double get height;
/// Create a copy of ListItemWrapper
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListItemWrapperCopyWith<ListItemWrapper> get copyWith => _$ListItemWrapperCopyWithImpl<ListItemWrapper>(this as ListItemWrapper, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListItemWrapper&&(identical(other.item, item) || other.item == item)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,item,height);

@override
String toString() {
  return 'ListItemWrapper(item: $item, height: $height)';
}


}

/// @nodoc
abstract mixin class $ListItemWrapperCopyWith<$Res>  {
  factory $ListItemWrapperCopyWith(ListItemWrapper value, $Res Function(ListItemWrapper) _then) = _$ListItemWrapperCopyWithImpl;
@useResult
$Res call({
 ListItem item, double height
});


$ListItemCopyWith<$Res> get item;

}
/// @nodoc
class _$ListItemWrapperCopyWithImpl<$Res>
    implements $ListItemWrapperCopyWith<$Res> {
  _$ListItemWrapperCopyWithImpl(this._self, this._then);

  final ListItemWrapper _self;
  final $Res Function(ListItemWrapper) _then;

/// Create a copy of ListItemWrapper
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = null,Object? height = null,}) {
  return _then(_self.copyWith(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ListItem,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of ListItemWrapper
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListItemCopyWith<$Res> get item {
  
  return $ListItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// @nodoc


class _ListItemWrapper implements ListItemWrapper {
   _ListItemWrapper({required this.item, required this.height});
  

@override final  ListItem item;
@override final  double height;

/// Create a copy of ListItemWrapper
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListItemWrapperCopyWith<_ListItemWrapper> get copyWith => __$ListItemWrapperCopyWithImpl<_ListItemWrapper>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListItemWrapper&&(identical(other.item, item) || other.item == item)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,item,height);

@override
String toString() {
  return 'ListItemWrapper(item: $item, height: $height)';
}


}

/// @nodoc
abstract mixin class _$ListItemWrapperCopyWith<$Res> implements $ListItemWrapperCopyWith<$Res> {
  factory _$ListItemWrapperCopyWith(_ListItemWrapper value, $Res Function(_ListItemWrapper) _then) = __$ListItemWrapperCopyWithImpl;
@override @useResult
$Res call({
 ListItem item, double height
});


@override $ListItemCopyWith<$Res> get item;

}
/// @nodoc
class __$ListItemWrapperCopyWithImpl<$Res>
    implements _$ListItemWrapperCopyWith<$Res> {
  __$ListItemWrapperCopyWithImpl(this._self, this._then);

  final _ListItemWrapper _self;
  final $Res Function(_ListItemWrapper) _then;

/// Create a copy of ListItemWrapper
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = null,Object? height = null,}) {
  return _then(_ListItemWrapper(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ListItem,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ListItemWrapper
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListItemCopyWith<$Res> get item {
  
  return $ListItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

// dart format on
