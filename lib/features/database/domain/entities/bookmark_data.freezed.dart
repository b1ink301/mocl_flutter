// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookmarkData {

 SiteType get siteType; int get id; String get title; String get url; String get board; String get boardTitle; String get info; String get time; String get reply; String get userId; String get nickName; String get nickImage; int get savedAt;
/// Create a copy of BookmarkData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkDataCopyWith<BookmarkData> get copyWith => _$BookmarkDataCopyWithImpl<BookmarkData>(this as BookmarkData, _$identity);

  /// Serializes this BookmarkData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkData&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.board, board) || other.board == board)&&(identical(other.boardTitle, boardTitle) || other.boardTitle == boardTitle)&&(identical(other.info, info) || other.info == info)&&(identical(other.time, time) || other.time == time)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.nickImage, nickImage) || other.nickImage == nickImage)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteType,id,title,url,board,boardTitle,info,time,reply,userId,nickName,nickImage,savedAt);

@override
String toString() {
  return 'BookmarkData(siteType: $siteType, id: $id, title: $title, url: $url, board: $board, boardTitle: $boardTitle, info: $info, time: $time, reply: $reply, userId: $userId, nickName: $nickName, nickImage: $nickImage, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $BookmarkDataCopyWith<$Res>  {
  factory $BookmarkDataCopyWith(BookmarkData value, $Res Function(BookmarkData) _then) = _$BookmarkDataCopyWithImpl;
@useResult
$Res call({
 SiteType siteType, int id, String title, String url, String board, String boardTitle, String info, String time, String reply, String userId, String nickName, String nickImage, int savedAt
});




}
/// @nodoc
class _$BookmarkDataCopyWithImpl<$Res>
    implements $BookmarkDataCopyWith<$Res> {
  _$BookmarkDataCopyWithImpl(this._self, this._then);

  final BookmarkData _self;
  final $Res Function(BookmarkData) _then;

/// Create a copy of BookmarkData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? siteType = null,Object? id = null,Object? title = null,Object? url = null,Object? board = null,Object? boardTitle = null,Object? info = null,Object? time = null,Object? reply = null,Object? userId = null,Object? nickName = null,Object? nickImage = null,Object? savedAt = null,}) {
  return _then(BookmarkData(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,boardTitle: null == boardTitle ? _self.boardTitle : boardTitle // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,nickName: null == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String,nickImage: null == nickImage ? _self.nickImage : nickImage // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookmarkData].
extension BookmarkDataPatterns on BookmarkData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookmarkData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookmarkData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookmarkData value)  $default,){
final _that = this;
switch (_that) {
case _BookmarkData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookmarkData value)?  $default,){
final _that = this;
switch (_that) {
case _BookmarkData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SiteType siteType,  int id,  String title,  String url,  String board,  String boardTitle,  String info,  String time,  String reply,  String userId,  String nickName,  String nickImage,  int savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookmarkData() when $default != null:
return $default(_that.siteType,_that.id,_that.title,_that.url,_that.board,_that.boardTitle,_that.info,_that.time,_that.reply,_that.userId,_that.nickName,_that.nickImage,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SiteType siteType,  int id,  String title,  String url,  String board,  String boardTitle,  String info,  String time,  String reply,  String userId,  String nickName,  String nickImage,  int savedAt)  $default,) {final _that = this;
switch (_that) {
case _BookmarkData():
return $default(_that.siteType,_that.id,_that.title,_that.url,_that.board,_that.boardTitle,_that.info,_that.time,_that.reply,_that.userId,_that.nickName,_that.nickImage,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SiteType siteType,  int id,  String title,  String url,  String board,  String boardTitle,  String info,  String time,  String reply,  String userId,  String nickName,  String nickImage,  int savedAt)?  $default,) {final _that = this;
switch (_that) {
case _BookmarkData() when $default != null:
return $default(_that.siteType,_that.id,_that.title,_that.url,_that.board,_that.boardTitle,_that.info,_that.time,_that.reply,_that.userId,_that.nickName,_that.nickImage,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookmarkData extends BookmarkData {
  const _BookmarkData({required this.siteType, required this.id, required this.title, required this.url, required this.board, required this.boardTitle, required this.info, required this.time, required this.reply, required this.userId, required this.nickName, required this.nickImage, required this.savedAt}): super._();
  factory _BookmarkData.fromJson(Map<String, dynamic> json) => _$BookmarkDataFromJson(json);

@override final  SiteType siteType;
@override final  int id;
@override final  String title;
@override final  String url;
@override final  String board;
@override final  String boardTitle;
@override final  String info;
@override final  String time;
@override final  String reply;
@override final  String userId;
@override final  String nickName;
@override final  String nickImage;
@override final  int savedAt;

/// Create a copy of BookmarkData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkDataCopyWith<_BookmarkData> get copyWith => __$BookmarkDataCopyWithImpl<_BookmarkData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookmarkDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookmarkData&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.board, board) || other.board == board)&&(identical(other.boardTitle, boardTitle) || other.boardTitle == boardTitle)&&(identical(other.info, info) || other.info == info)&&(identical(other.time, time) || other.time == time)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.nickImage, nickImage) || other.nickImage == nickImage)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteType,id,title,url,board,boardTitle,info,time,reply,userId,nickName,nickImage,savedAt);

@override
String toString() {
  return 'BookmarkData(siteType: $siteType, id: $id, title: $title, url: $url, board: $board, boardTitle: $boardTitle, info: $info, time: $time, reply: $reply, userId: $userId, nickName: $nickName, nickImage: $nickImage, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$BookmarkDataCopyWith<$Res> implements $BookmarkDataCopyWith<$Res> {
  factory _$BookmarkDataCopyWith(_BookmarkData value, $Res Function(_BookmarkData) _then) = __$BookmarkDataCopyWithImpl;
@override @useResult
$Res call({
 SiteType siteType, int id, String title, String url, String board, String boardTitle, String info, String time, String reply, String userId, String nickName, String nickImage, int savedAt
});




}
/// @nodoc
class __$BookmarkDataCopyWithImpl<$Res>
    implements _$BookmarkDataCopyWith<$Res> {
  __$BookmarkDataCopyWithImpl(this._self, this._then);

  final _BookmarkData _self;
  final $Res Function(_BookmarkData) _then;

/// Create a copy of BookmarkData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteType = null,Object? id = null,Object? title = null,Object? url = null,Object? board = null,Object? boardTitle = null,Object? info = null,Object? time = null,Object? reply = null,Object? userId = null,Object? nickName = null,Object? nickImage = null,Object? savedAt = null,}) {
  return _then(_BookmarkData(
siteType: null == siteType ? _self.siteType : siteType // ignore: cast_nullable_to_non_nullable
as SiteType,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as String,boardTitle: null == boardTitle ? _self.boardTitle : boardTitle // ignore: cast_nullable_to_non_nullable
as String,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,nickName: null == nickName ? _self.nickName : nickName // ignore: cast_nullable_to_non_nullable
as String,nickImage: null == nickImage ? _self.nickImage : nickImage // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
