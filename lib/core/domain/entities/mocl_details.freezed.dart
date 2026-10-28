// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Details {

 String get title; String get time; String get viewCount; String get likeCount; String get bodyHtml; String get info; UserInfo get userInfo; List<CommentItem> get comments; Recents? get recents; String get csrf; String get category; Map<String, dynamic>? get extraData; bool get isLoggedIn; Map<String, String> get commentParams;
/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailsCopyWith<Details> get copyWith => _$DetailsCopyWithImpl<Details>(this as Details, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Details;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Details&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.viewCount, _this.viewCount) || other.viewCount == _this.viewCount)&&(identical(other.likeCount, _this.likeCount) || other.likeCount == _this.likeCount)&&(identical(other.bodyHtml, _this.bodyHtml) || other.bodyHtml == _this.bodyHtml)&&(identical(other.info, _this.info) || other.info == _this.info)&&(identical(other.userInfo, _this.userInfo) || other.userInfo == _this.userInfo)&&const DeepCollectionEquality().equals(other.comments, _this.comments)&&(identical(other.recents, _this.recents) || other.recents == _this.recents)&&(identical(other.csrf, _this.csrf) || other.csrf == _this.csrf)&&(identical(other.category, _this.category) || other.category == _this.category)&&const DeepCollectionEquality().equals(other.extraData, _this.extraData)&&(identical(other.isLoggedIn, _this.isLoggedIn) || other.isLoggedIn == _this.isLoggedIn)&&const DeepCollectionEquality().equals(other.commentParams, _this.commentParams));
}


@override
int get hashCode {
  final _this = this as Details;
  return Object.hash(runtimeType,_this.title,_this.time,_this.viewCount,_this.likeCount,_this.bodyHtml,_this.info,_this.userInfo,const DeepCollectionEquality().hash(_this.comments),_this.recents,_this.csrf,_this.category,const DeepCollectionEquality().hash(_this.extraData),_this.isLoggedIn,const DeepCollectionEquality().hash(_this.commentParams));
}

@override
String toString() {
  final _this = this as Details;
  return 'Details(title: ${_this.title}, time: ${_this.time}, viewCount: ${_this.viewCount}, likeCount: ${_this.likeCount}, bodyHtml: ${_this.bodyHtml}, info: ${_this.info}, userInfo: ${_this.userInfo}, comments: ${_this.comments}, recents: ${_this.recents}, csrf: ${_this.csrf}, category: ${_this.category}, extraData: ${_this.extraData}, isLoggedIn: ${_this.isLoggedIn}, commentParams: ${_this.commentParams})';
}


}

/// @nodoc
abstract mixin class $DetailsCopyWith<$Res>  {
  factory $DetailsCopyWith(Details value, $Res Function(Details) _then) = _$DetailsCopyWithImpl;
@useResult
$Res call({
 String title, String time, String viewCount, String likeCount, String bodyHtml, String info, UserInfo userInfo, List<CommentItem> comments, Recents? recents, String csrf, String category, Map<String, dynamic>? extraData, bool isLoggedIn, Map<String, String> commentParams
});


$UserInfoCopyWith<$Res> get userInfo;$RecentsCopyWith<$Res>? get recents;

}
/// @nodoc
class _$DetailsCopyWithImpl<$Res>
    implements $DetailsCopyWith<$Res> {
  _$DetailsCopyWithImpl(this._self, this._then);

  final Details _self;
  final $Res Function(Details) _then;

/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? time = null,Object? viewCount = null,Object? likeCount = null,Object? bodyHtml = null,Object? info = null,Object? userInfo = null,Object? comments = null,Object? recents = freezed,Object? csrf = null,Object? category = null,Object? extraData = freezed,Object? isLoggedIn = null,Object? commentParams = null,}) {
  return _then(Details(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as String,bodyHtml: null == bodyHtml ? _self.bodyHtml : bodyHtml // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserInfo,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentItem>,recents: freezed == recents ? _self.recents : recents // ignore: cast_nullable_to_non_nullable
as Recents?,csrf: null == csrf ? _self.csrf : csrf // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,extraData: freezed == extraData ? _self.extraData : extraData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,commentParams: null == commentParams ? _self.commentParams : commentParams // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}
/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get userInfo {
  
  return $UserInfoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentsCopyWith<$Res>? get recents {
    if (_self.recents == null) {
    return null;
  }

  return $RecentsCopyWith<$Res>(_self.recents!, (value) {
    return _then(_self.copyWith(recents: value));
  });
}
}


/// Adds pattern-matching-related methods to [Details].
extension DetailsPatterns on Details {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Details value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Details() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Details value)  $default,){
final _that = this;
switch (_that) {
case _Details():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Details value)?  $default,){
final _that = this;
switch (_that) {
case _Details() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String time,  String viewCount,  String likeCount,  String bodyHtml,  String info,  UserInfo userInfo,  List<CommentItem> comments,  Recents? recents,  String csrf,  String category,  Map<String, dynamic>? extraData,  bool isLoggedIn,  Map<String, String> commentParams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Details() when $default != null:
return $default(_that.title,_that.time,_that.viewCount,_that.likeCount,_that.bodyHtml,_that.info,_that.userInfo,_that.comments,_that.recents,_that.csrf,_that.category,_that.extraData,_that.isLoggedIn,_that.commentParams);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String time,  String viewCount,  String likeCount,  String bodyHtml,  String info,  UserInfo userInfo,  List<CommentItem> comments,  Recents? recents,  String csrf,  String category,  Map<String, dynamic>? extraData,  bool isLoggedIn,  Map<String, String> commentParams)  $default,) {final _that = this;
switch (_that) {
case _Details():
return $default(_that.title,_that.time,_that.viewCount,_that.likeCount,_that.bodyHtml,_that.info,_that.userInfo,_that.comments,_that.recents,_that.csrf,_that.category,_that.extraData,_that.isLoggedIn,_that.commentParams);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String time,  String viewCount,  String likeCount,  String bodyHtml,  String info,  UserInfo userInfo,  List<CommentItem> comments,  Recents? recents,  String csrf,  String category,  Map<String, dynamic>? extraData,  bool isLoggedIn,  Map<String, String> commentParams)?  $default,) {final _that = this;
switch (_that) {
case _Details() when $default != null:
return $default(_that.title,_that.time,_that.viewCount,_that.likeCount,_that.bodyHtml,_that.info,_that.userInfo,_that.comments,_that.recents,_that.csrf,_that.category,_that.extraData,_that.isLoggedIn,_that.commentParams);case _:
  return null;

}
}

}

/// @nodoc


class _Details implements Details {
  const _Details({required this.title, required this.time, required this.viewCount, required this.likeCount, required this.bodyHtml, required this.info, required this.userInfo, required  List<CommentItem> comments, this.recents = null, this.csrf = '', this.category = '',  Map<String, dynamic>? extraData, this.isLoggedIn = false,  Map<String, String> commentParams = const <String, String>{}}): _comments = comments,_extraData = extraData,_commentParams = commentParams;
  

@override final  String title;
@override final  String time;
@override final  String viewCount;
@override final  String likeCount;
@override final  String bodyHtml;
@override final  String info;
@override final  UserInfo userInfo;
 final  List<CommentItem> _comments;
@override List<CommentItem> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@override@JsonKey() final  Recents? recents;
@override@JsonKey() final  String csrf;
@override@JsonKey() final  String category;
 final  Map<String, dynamic>? _extraData;
@override Map<String, dynamic>? get extraData {
  final value = _extraData;
  if (value == null) return null;
  if (_extraData is EqualUnmodifiableMapView) return _extraData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  bool isLoggedIn;
 final  Map<String, String> _commentParams;
@override@JsonKey() Map<String, String> get commentParams {
  if (_commentParams is EqualUnmodifiableMapView) return _commentParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_commentParams);
}


/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailsCopyWith<_Details> get copyWith => __$DetailsCopyWithImpl<_Details>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Details&&(identical(other.title, title) || other.title == title)&&(identical(other.time, time) || other.time == time)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.bodyHtml, bodyHtml) || other.bodyHtml == bodyHtml)&&(identical(other.info, info) || other.info == info)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&const DeepCollectionEquality().equals(other.comments, _comments)&&(identical(other.recents, recents) || other.recents == recents)&&(identical(other.csrf, csrf) || other.csrf == csrf)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.extraData, _extraData)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&const DeepCollectionEquality().equals(other.commentParams, _commentParams));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,time,viewCount,likeCount,bodyHtml,info,userInfo,const DeepCollectionEquality().hash(_comments),recents,csrf,category,const DeepCollectionEquality().hash(_extraData),isLoggedIn,const DeepCollectionEquality().hash(_commentParams));
}

@override
String toString() {
    return 'Details(title: $title, time: $time, viewCount: $viewCount, likeCount: $likeCount, bodyHtml: $bodyHtml, info: $info, userInfo: $userInfo, comments: $comments, recents: $recents, csrf: $csrf, category: $category, extraData: $extraData, isLoggedIn: $isLoggedIn, commentParams: $commentParams)';
}


}

/// @nodoc
abstract mixin class _$DetailsCopyWith<$Res> implements $DetailsCopyWith<$Res> {
  factory _$DetailsCopyWith(_Details value, $Res Function(_Details) _then) = __$DetailsCopyWithImpl;
@override @useResult
$Res call({
 String title, String time, String viewCount, String likeCount, String bodyHtml, String info, UserInfo userInfo, List<CommentItem> comments, Recents? recents, String csrf, String category, Map<String, dynamic>? extraData, bool isLoggedIn, Map<String, String> commentParams
});


@override $UserInfoCopyWith<$Res> get userInfo;@override $RecentsCopyWith<$Res>? get recents;

}
/// @nodoc
class __$DetailsCopyWithImpl<$Res>
    implements _$DetailsCopyWith<$Res> {
  __$DetailsCopyWithImpl(this._self, this._then);

  final _Details _self;
  final $Res Function(_Details) _then;

/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? time = null,Object? viewCount = null,Object? likeCount = null,Object? bodyHtml = null,Object? info = null,Object? userInfo = null,Object? comments = null,Object? recents = freezed,Object? csrf = null,Object? category = null,Object? extraData = freezed,Object? isLoggedIn = null,Object? commentParams = null,}) {
  return _then(_Details(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as String,bodyHtml: null == bodyHtml ? _self.bodyHtml : bodyHtml // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserInfo,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentItem>,recents: freezed == recents ? _self.recents : recents // ignore: cast_nullable_to_non_nullable
as Recents?,csrf: null == csrf ? _self.csrf : csrf // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,extraData: freezed == extraData ? _self._extraData : extraData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,commentParams: null == commentParams ? _self._commentParams : commentParams // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get userInfo {
  
  return $UserInfoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentsCopyWith<$Res>? get recents {
    if (_self.recents == null) {
    return null;
  }

  return $RecentsCopyWith<$Res>(_self.recents!, (value) {
    return _then(_self.copyWith(recents: value));
  });
}
}

// dart format on
