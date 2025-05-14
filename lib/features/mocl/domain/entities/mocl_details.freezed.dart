// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Details {

 String get title; String get time; String get viewCount; String get likeCount; String get bodyHtml; String get csrf; String get info; UserInfo get userInfo; List<CommentItem> get comments;
/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailsCopyWith<Details> get copyWith => _$DetailsCopyWithImpl<Details>(this as Details, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Details&&(identical(other.title, title) || other.title == title)&&(identical(other.time, time) || other.time == time)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.bodyHtml, bodyHtml) || other.bodyHtml == bodyHtml)&&(identical(other.csrf, csrf) || other.csrf == csrf)&&(identical(other.info, info) || other.info == info)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&const DeepCollectionEquality().equals(other.comments, comments));
}


@override
int get hashCode => Object.hash(runtimeType,title,time,viewCount,likeCount,bodyHtml,csrf,info,userInfo,const DeepCollectionEquality().hash(comments));

@override
String toString() {
  return 'Details(title: $title, time: $time, viewCount: $viewCount, likeCount: $likeCount, bodyHtml: $bodyHtml, csrf: $csrf, info: $info, userInfo: $userInfo, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $DetailsCopyWith<$Res>  {
  factory $DetailsCopyWith(Details value, $Res Function(Details) _then) = _$DetailsCopyWithImpl;
@useResult
$Res call({
 String title, String time, String viewCount, String likeCount, String bodyHtml, String csrf, String info, UserInfo userInfo, List<CommentItem> comments
});


$UserInfoCopyWith<$Res> get userInfo;

}
/// @nodoc
class _$DetailsCopyWithImpl<$Res>
    implements $DetailsCopyWith<$Res> {
  _$DetailsCopyWithImpl(this._self, this._then);

  final Details _self;
  final $Res Function(Details) _then;

/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? time = null,Object? viewCount = null,Object? likeCount = null,Object? bodyHtml = null,Object? csrf = null,Object? info = null,Object? userInfo = null,Object? comments = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as String,bodyHtml: null == bodyHtml ? _self.bodyHtml : bodyHtml // ignore: cast_nullable_to_non_nullable
as String,csrf: null == csrf ? _self.csrf : csrf // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserInfo,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentItem>,
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
}
}


/// @nodoc


class _Details implements Details {
  const _Details({required this.title, required this.time, required this.viewCount, required this.likeCount, required this.bodyHtml, required this.csrf, required this.info, required this.userInfo, required final  List<CommentItem> comments}): _comments = comments;
  

@override final  String title;
@override final  String time;
@override final  String viewCount;
@override final  String likeCount;
@override final  String bodyHtml;
@override final  String csrf;
@override final  String info;
@override final  UserInfo userInfo;
 final  List<CommentItem> _comments;
@override List<CommentItem> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}


/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailsCopyWith<_Details> get copyWith => __$DetailsCopyWithImpl<_Details>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Details&&(identical(other.title, title) || other.title == title)&&(identical(other.time, time) || other.time == time)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.bodyHtml, bodyHtml) || other.bodyHtml == bodyHtml)&&(identical(other.csrf, csrf) || other.csrf == csrf)&&(identical(other.info, info) || other.info == info)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&const DeepCollectionEquality().equals(other._comments, _comments));
}


@override
int get hashCode => Object.hash(runtimeType,title,time,viewCount,likeCount,bodyHtml,csrf,info,userInfo,const DeepCollectionEquality().hash(_comments));

@override
String toString() {
  return 'Details(title: $title, time: $time, viewCount: $viewCount, likeCount: $likeCount, bodyHtml: $bodyHtml, csrf: $csrf, info: $info, userInfo: $userInfo, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$DetailsCopyWith<$Res> implements $DetailsCopyWith<$Res> {
  factory _$DetailsCopyWith(_Details value, $Res Function(_Details) _then) = __$DetailsCopyWithImpl;
@override @useResult
$Res call({
 String title, String time, String viewCount, String likeCount, String bodyHtml, String csrf, String info, UserInfo userInfo, List<CommentItem> comments
});


@override $UserInfoCopyWith<$Res> get userInfo;

}
/// @nodoc
class __$DetailsCopyWithImpl<$Res>
    implements _$DetailsCopyWith<$Res> {
  __$DetailsCopyWithImpl(this._self, this._then);

  final _Details _self;
  final $Res Function(_Details) _then;

/// Create a copy of Details
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? time = null,Object? viewCount = null,Object? likeCount = null,Object? bodyHtml = null,Object? csrf = null,Object? info = null,Object? userInfo = null,Object? comments = null,}) {
  return _then(_Details(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as String,bodyHtml: null == bodyHtml ? _self.bodyHtml : bodyHtml // ignore: cast_nullable_to_non_nullable
as String,csrf: null == csrf ? _self.csrf : csrf // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserInfo,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentItem>,
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
}
}

// dart format on
