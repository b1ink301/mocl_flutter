// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListItem implements DiagnosticableTreeMixin {

 int get id; String get title; String get reply; String get category; String get time; String get url; String get info; String get board; String get boardTitle; String get like; String get hit; UserInfo get userInfo; bool get hasImage; bool get isRead;
/// Create a copy of ListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListItemCopyWith<ListItem> get copyWith => _$ListItemCopyWithImpl<ListItem>(this as ListItem, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as ListItem;
  properties
    ..add(DiagnosticsProperty('type', 'ListItem'))
    ..add(DiagnosticsProperty('id', _this.id))..add(DiagnosticsProperty('title', _this.title))..add(DiagnosticsProperty('reply', _this.reply))..add(DiagnosticsProperty('category', _this.category))..add(DiagnosticsProperty('time', _this.time))..add(DiagnosticsProperty('url', _this.url))..add(DiagnosticsProperty('info', _this.info))..add(DiagnosticsProperty('board', _this.board))..add(DiagnosticsProperty('boardTitle', _this.boardTitle))..add(DiagnosticsProperty('like', _this.like))..add(DiagnosticsProperty('hit', _this.hit))..add(DiagnosticsProperty('userInfo', _this.userInfo))..add(DiagnosticsProperty('hasImage', _this.hasImage))..add(DiagnosticsProperty('isRead', _this.isRead));
}

@override
bool operator ==(Object other) {
  final _this = this as ListItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.reply, _this.reply) || other.reply == _this.reply)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.info, _this.info) || other.info == _this.info)&&(identical(other.board, _this.board) || other.board == _this.board)&&(identical(other.boardTitle, _this.boardTitle) || other.boardTitle == _this.boardTitle)&&(identical(other.like, _this.like) || other.like == _this.like)&&(identical(other.hit, _this.hit) || other.hit == _this.hit)&&(identical(other.userInfo, _this.userInfo) || other.userInfo == _this.userInfo)&&(identical(other.hasImage, _this.hasImage) || other.hasImage == _this.hasImage)&&(identical(other.isRead, _this.isRead) || other.isRead == _this.isRead));
}


@override
int get hashCode {
  final _this = this as ListItem;
  return Object.hash(runtimeType,_this.id,_this.title,_this.reply,_this.category,_this.time,_this.url,_this.info,_this.board,_this.boardTitle,_this.like,_this.hit,_this.userInfo,_this.hasImage,_this.isRead);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as ListItem;
  return 'ListItem(id: ${_this.id}, title: ${_this.title}, reply: ${_this.reply}, category: ${_this.category}, time: ${_this.time}, url: ${_this.url}, info: ${_this.info}, board: ${_this.board}, boardTitle: ${_this.boardTitle}, like: ${_this.like}, hit: ${_this.hit}, userInfo: ${_this.userInfo}, hasImage: ${_this.hasImage}, isRead: ${_this.isRead})';
}


}

/// @nodoc
abstract mixin class $ListItemCopyWith<$Res>  {
  factory $ListItemCopyWith(ListItem value, $Res Function(ListItem) _then) = _$ListItemCopyWithImpl;
@useResult
$Res call({
 int id, String title, String reply, String category, String time, String url, String info, String board, String boardTitle, String like, String hit, UserInfo userInfo, bool hasImage, bool isRead
});


$UserInfoCopyWith<$Res> get userInfo;

}
/// @nodoc
class _$ListItemCopyWithImpl<$Res>
    implements $ListItemCopyWith<$Res> {
  _$ListItemCopyWithImpl(this._self, this._then);

  final ListItem _self;
  final $Res Function(ListItem) _then;

/// Create a copy of ListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? reply = null,Object? category = null,Object? time = null,Object? url = null,Object? info = null,Object? board = null,Object? boardTitle = null,Object? like = null,Object? hit = null,Object? userInfo = null,Object? hasImage = null,Object? isRead = null,}) {
  return _then(ListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,boardTitle: null == boardTitle ? _self.boardTitle : boardTitle // ignore: cast_nullable_to_non_nullable
as String,like: null == like ? _self.like : like // ignore: cast_nullable_to_non_nullable
as String,hit: null == hit ? _self.hit : hit // ignore: cast_nullable_to_non_nullable
as String,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserInfo,hasImage: null == hasImage ? _self.hasImage : hasImage // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ListItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserInfoCopyWith<$Res> get userInfo {
  
  return $UserInfoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListItem].
extension ListItemPatterns on ListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListItem value)  $default,){
final _that = this;
switch (_that) {
case _ListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListItem value)?  $default,){
final _that = this;
switch (_that) {
case _ListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String reply,  String category,  String time,  String url,  String info,  String board,  String boardTitle,  String like,  String hit,  UserInfo userInfo,  bool hasImage,  bool isRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListItem() when $default != null:
return $default(_that.id,_that.title,_that.reply,_that.category,_that.time,_that.url,_that.info,_that.board,_that.boardTitle,_that.like,_that.hit,_that.userInfo,_that.hasImage,_that.isRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String reply,  String category,  String time,  String url,  String info,  String board,  String boardTitle,  String like,  String hit,  UserInfo userInfo,  bool hasImage,  bool isRead)  $default,) {final _that = this;
switch (_that) {
case _ListItem():
return $default(_that.id,_that.title,_that.reply,_that.category,_that.time,_that.url,_that.info,_that.board,_that.boardTitle,_that.like,_that.hit,_that.userInfo,_that.hasImage,_that.isRead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String reply,  String category,  String time,  String url,  String info,  String board,  String boardTitle,  String like,  String hit,  UserInfo userInfo,  bool hasImage,  bool isRead)?  $default,) {final _that = this;
switch (_that) {
case _ListItem() when $default != null:
return $default(_that.id,_that.title,_that.reply,_that.category,_that.time,_that.url,_that.info,_that.board,_that.boardTitle,_that.like,_that.hit,_that.userInfo,_that.hasImage,_that.isRead);case _:
  return null;

}
}

}

/// @nodoc


class _ListItem with DiagnosticableTreeMixin implements ListItem {
  const _ListItem({required this.id, required this.title, required this.reply, required this.category, required this.time, required this.url, required this.info, required this.board, required this.boardTitle, required this.like, required this.hit, required this.userInfo, required this.hasImage, required this.isRead});
  

@override final  int id;
@override final  String title;
@override final  String reply;
@override final  String category;
@override final  String time;
@override final  String url;
@override final  String info;
@override final  String board;
@override final  String boardTitle;
@override final  String like;
@override final  String hit;
@override final  UserInfo userInfo;
@override final  bool hasImage;
@override final  bool isRead;

/// Create a copy of ListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListItemCopyWith<_ListItem> get copyWith => __$ListItemCopyWithImpl<_ListItem>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'ListItem'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('reply', reply))..add(DiagnosticsProperty('category', category))..add(DiagnosticsProperty('time', time))..add(DiagnosticsProperty('url', url))..add(DiagnosticsProperty('info', info))..add(DiagnosticsProperty('board', board))..add(DiagnosticsProperty('boardTitle', boardTitle))..add(DiagnosticsProperty('like', like))..add(DiagnosticsProperty('hit', hit))..add(DiagnosticsProperty('userInfo', userInfo))..add(DiagnosticsProperty('hasImage', hasImage))..add(DiagnosticsProperty('isRead', isRead));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.category, category) || other.category == category)&&(identical(other.time, time) || other.time == time)&&(identical(other.url, url) || other.url == url)&&(identical(other.info, info) || other.info == info)&&(identical(other.board, board) || other.board == board)&&(identical(other.boardTitle, boardTitle) || other.boardTitle == boardTitle)&&(identical(other.like, like) || other.like == like)&&(identical(other.hit, hit) || other.hit == hit)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.hasImage, hasImage) || other.hasImage == hasImage)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,reply,category,time,url,info,board,boardTitle,like,hit,userInfo,hasImage,isRead);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'ListItem(id: $id, title: $title, reply: $reply, category: $category, time: $time, url: $url, info: $info, board: $board, boardTitle: $boardTitle, like: $like, hit: $hit, userInfo: $userInfo, hasImage: $hasImage, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class _$ListItemCopyWith<$Res> implements $ListItemCopyWith<$Res> {
  factory _$ListItemCopyWith(_ListItem value, $Res Function(_ListItem) _then) = __$ListItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String reply, String category, String time, String url, String info, String board, String boardTitle, String like, String hit, UserInfo userInfo, bool hasImage, bool isRead
});


@override $UserInfoCopyWith<$Res> get userInfo;

}
/// @nodoc
class __$ListItemCopyWithImpl<$Res>
    implements _$ListItemCopyWith<$Res> {
  __$ListItemCopyWithImpl(this._self, this._then);

  final _ListItem _self;
  final $Res Function(_ListItem) _then;

/// Create a copy of ListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? reply = null,Object? category = null,Object? time = null,Object? url = null,Object? info = null,Object? board = null,Object? boardTitle = null,Object? like = null,Object? hit = null,Object? userInfo = null,Object? hasImage = null,Object? isRead = null,}) {
  return _then(_ListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,boardTitle: null == boardTitle ? _self.boardTitle : boardTitle // ignore: cast_nullable_to_non_nullable
as String,like: null == like ? _self.like : like // ignore: cast_nullable_to_non_nullable
as String,hit: null == hit ? _self.hit : hit // ignore: cast_nullable_to_non_nullable
as String,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserInfo,hasImage: null == hasImage ? _self.hasImage : hasImage // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ListItem
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
