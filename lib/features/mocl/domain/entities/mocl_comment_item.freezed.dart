// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_comment_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommentItem {

 int get id; String get bodyHtml; String get mediaHtml; bool get isVideo; String get time; String get info; String get likeCount; UserInfo get userInfo; String get authorId; bool get isReply;
/// Create a copy of CommentItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentItemCopyWith<CommentItem> get copyWith => _$CommentItemCopyWithImpl<CommentItem>(this as CommentItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentItem&&(identical(other.id, id) || other.id == id)&&(identical(other.bodyHtml, bodyHtml) || other.bodyHtml == bodyHtml)&&(identical(other.mediaHtml, mediaHtml) || other.mediaHtml == mediaHtml)&&(identical(other.isVideo, isVideo) || other.isVideo == isVideo)&&(identical(other.time, time) || other.time == time)&&(identical(other.info, info) || other.info == info)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.isReply, isReply) || other.isReply == isReply));
}


@override
int get hashCode => Object.hash(runtimeType,id,bodyHtml,mediaHtml,isVideo,time,info,likeCount,userInfo,authorId,isReply);

@override
String toString() {
  return 'CommentItem(id: $id, bodyHtml: $bodyHtml, mediaHtml: $mediaHtml, isVideo: $isVideo, time: $time, info: $info, likeCount: $likeCount, userInfo: $userInfo, authorId: $authorId, isReply: $isReply)';
}


}

/// @nodoc
abstract mixin class $CommentItemCopyWith<$Res>  {
  factory $CommentItemCopyWith(CommentItem value, $Res Function(CommentItem) _then) = _$CommentItemCopyWithImpl;
@useResult
$Res call({
 int id, String bodyHtml, String mediaHtml, bool isVideo, String time, String info, String likeCount, UserInfo userInfo, String authorId, bool isReply
});


$UserInfoCopyWith<$Res> get userInfo;

}
/// @nodoc
class _$CommentItemCopyWithImpl<$Res>
    implements $CommentItemCopyWith<$Res> {
  _$CommentItemCopyWithImpl(this._self, this._then);

  final CommentItem _self;
  final $Res Function(CommentItem) _then;

/// Create a copy of CommentItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bodyHtml = null,Object? mediaHtml = null,Object? isVideo = null,Object? time = null,Object? info = null,Object? likeCount = null,Object? userInfo = null,Object? authorId = null,Object? isReply = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,bodyHtml: null == bodyHtml ? _self.bodyHtml : bodyHtml // ignore: cast_nullable_to_non_nullable
as String,mediaHtml: null == mediaHtml ? _self.mediaHtml : mediaHtml // ignore: cast_nullable_to_non_nullable
as String,isVideo: null == isVideo ? _self.isVideo : isVideo // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as String,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserInfo,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,isReply: null == isReply ? _self.isReply : isReply // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CommentItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get userInfo {
  
  return $UserInfoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentItem].
extension CommentItemPatterns on CommentItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentItem value)  $default,){
final _that = this;
switch (_that) {
case _CommentItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentItem value)?  $default,){
final _that = this;
switch (_that) {
case _CommentItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String bodyHtml,  String mediaHtml,  bool isVideo,  String time,  String info,  String likeCount,  UserInfo userInfo,  String authorId,  bool isReply)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentItem() when $default != null:
return $default(_that.id,_that.bodyHtml,_that.mediaHtml,_that.isVideo,_that.time,_that.info,_that.likeCount,_that.userInfo,_that.authorId,_that.isReply);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String bodyHtml,  String mediaHtml,  bool isVideo,  String time,  String info,  String likeCount,  UserInfo userInfo,  String authorId,  bool isReply)  $default,) {final _that = this;
switch (_that) {
case _CommentItem():
return $default(_that.id,_that.bodyHtml,_that.mediaHtml,_that.isVideo,_that.time,_that.info,_that.likeCount,_that.userInfo,_that.authorId,_that.isReply);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String bodyHtml,  String mediaHtml,  bool isVideo,  String time,  String info,  String likeCount,  UserInfo userInfo,  String authorId,  bool isReply)?  $default,) {final _that = this;
switch (_that) {
case _CommentItem() when $default != null:
return $default(_that.id,_that.bodyHtml,_that.mediaHtml,_that.isVideo,_that.time,_that.info,_that.likeCount,_that.userInfo,_that.authorId,_that.isReply);case _:
  return null;

}
}

}

/// @nodoc


class _CommentItem implements CommentItem {
  const _CommentItem({required this.id, required this.bodyHtml, required this.mediaHtml, required this.isVideo, required this.time, required this.info, required this.likeCount, required this.userInfo, required this.authorId, required this.isReply});
  

@override final  int id;
@override final  String bodyHtml;
@override final  String mediaHtml;
@override final  bool isVideo;
@override final  String time;
@override final  String info;
@override final  String likeCount;
@override final  UserInfo userInfo;
@override final  String authorId;
@override final  bool isReply;

/// Create a copy of CommentItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentItemCopyWith<_CommentItem> get copyWith => __$CommentItemCopyWithImpl<_CommentItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentItem&&(identical(other.id, id) || other.id == id)&&(identical(other.bodyHtml, bodyHtml) || other.bodyHtml == bodyHtml)&&(identical(other.mediaHtml, mediaHtml) || other.mediaHtml == mediaHtml)&&(identical(other.isVideo, isVideo) || other.isVideo == isVideo)&&(identical(other.time, time) || other.time == time)&&(identical(other.info, info) || other.info == info)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.isReply, isReply) || other.isReply == isReply));
}


@override
int get hashCode => Object.hash(runtimeType,id,bodyHtml,mediaHtml,isVideo,time,info,likeCount,userInfo,authorId,isReply);

@override
String toString() {
  return 'CommentItem(id: $id, bodyHtml: $bodyHtml, mediaHtml: $mediaHtml, isVideo: $isVideo, time: $time, info: $info, likeCount: $likeCount, userInfo: $userInfo, authorId: $authorId, isReply: $isReply)';
}


}

/// @nodoc
abstract mixin class _$CommentItemCopyWith<$Res> implements $CommentItemCopyWith<$Res> {
  factory _$CommentItemCopyWith(_CommentItem value, $Res Function(_CommentItem) _then) = __$CommentItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String bodyHtml, String mediaHtml, bool isVideo, String time, String info, String likeCount, UserInfo userInfo, String authorId, bool isReply
});


@override $UserInfoCopyWith<$Res> get userInfo;

}
/// @nodoc
class __$CommentItemCopyWithImpl<$Res>
    implements _$CommentItemCopyWith<$Res> {
  __$CommentItemCopyWithImpl(this._self, this._then);

  final _CommentItem _self;
  final $Res Function(_CommentItem) _then;

/// Create a copy of CommentItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bodyHtml = null,Object? mediaHtml = null,Object? isVideo = null,Object? time = null,Object? info = null,Object? likeCount = null,Object? userInfo = null,Object? authorId = null,Object? isReply = null,}) {
  return _then(_CommentItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,bodyHtml: null == bodyHtml ? _self.bodyHtml : bodyHtml // ignore: cast_nullable_to_non_nullable
as String,mediaHtml: null == mediaHtml ? _self.mediaHtml : mediaHtml // ignore: cast_nullable_to_non_nullable
as String,isVideo: null == isVideo ? _self.isVideo : isVideo // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as String,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserInfo,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,isReply: null == isReply ? _self.isReply : isReply // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CommentItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get userInfo {
  
  return $UserInfoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}

// dart format on
