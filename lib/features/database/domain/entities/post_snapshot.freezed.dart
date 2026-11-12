// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostSnapshot {

 SiteType get siteType; int get id; String get title; String get url; String get board; String get boardTitle; String get info; String get time; String get reply; String get userId; String get nickName; String get nickImage; int get savedAt;/// 스크랩 폴더 id(`BookmarkFolder.id`). 한 글을 여러 폴더에 넣을 수 있다. 스크랩에서만 쓴다.
 List<String> get folders;/// 스크랩에 붙인 한 줄 메모. 스크랩에서만 쓴다.
 String get memo;
/// Create a copy of PostSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostSnapshotCopyWith<PostSnapshot> get copyWith => _$PostSnapshotCopyWithImpl<PostSnapshot>(this as PostSnapshot, _$identity);

  /// Serializes this PostSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostSnapshot&&(identical(other.siteType, _this.siteType) || other.siteType == _this.siteType)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.board, _this.board) || other.board == _this.board)&&(identical(other.boardTitle, _this.boardTitle) || other.boardTitle == _this.boardTitle)&&(identical(other.info, _this.info) || other.info == _this.info)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.reply, _this.reply) || other.reply == _this.reply)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.nickName, _this.nickName) || other.nickName == _this.nickName)&&(identical(other.nickImage, _this.nickImage) || other.nickImage == _this.nickImage)&&(identical(other.savedAt, _this.savedAt) || other.savedAt == _this.savedAt)&&const DeepCollectionEquality().equals(other.folders, _this.folders)&&(identical(other.memo, _this.memo) || other.memo == _this.memo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostSnapshot;
  return Object.hash(runtimeType,_this.siteType,_this.id,_this.title,_this.url,_this.board,_this.boardTitle,_this.info,_this.time,_this.reply,_this.userId,_this.nickName,_this.nickImage,_this.savedAt,const DeepCollectionEquality().hash(_this.folders),_this.memo);
}

@override
String toString() {
  final _this = this as PostSnapshot;
  return 'PostSnapshot(siteType: ${_this.siteType}, id: ${_this.id}, title: ${_this.title}, url: ${_this.url}, board: ${_this.board}, boardTitle: ${_this.boardTitle}, info: ${_this.info}, time: ${_this.time}, reply: ${_this.reply}, userId: ${_this.userId}, nickName: ${_this.nickName}, nickImage: ${_this.nickImage}, savedAt: ${_this.savedAt}, folders: ${_this.folders}, memo: ${_this.memo})';
}


}

/// @nodoc
abstract mixin class $PostSnapshotCopyWith<$Res>  {
  factory $PostSnapshotCopyWith(PostSnapshot value, $Res Function(PostSnapshot) _then) = _$PostSnapshotCopyWithImpl;
@useResult
$Res call({
 SiteType siteType, int id, String title, String url, String board, String boardTitle, String info, String time, String reply, String userId, String nickName, String nickImage, int savedAt, List<String> folders, String memo
});




}
/// @nodoc
class _$PostSnapshotCopyWithImpl<$Res>
    implements $PostSnapshotCopyWith<$Res> {
  _$PostSnapshotCopyWithImpl(this._self, this._then);

  final PostSnapshot _self;
  final $Res Function(PostSnapshot) _then;

/// Create a copy of PostSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? siteType = null,Object? id = null,Object? title = null,Object? url = null,Object? board = null,Object? boardTitle = null,Object? info = null,Object? time = null,Object? reply = null,Object? userId = null,Object? nickName = null,Object? nickImage = null,Object? savedAt = null,Object? folders = null,Object? memo = null,}) {
  return _then(PostSnapshot(
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
as int,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<String>,memo: null == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostSnapshot].
extension PostSnapshotPatterns on PostSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _PostSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _PostSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SiteType siteType,  int id,  String title,  String url,  String board,  String boardTitle,  String info,  String time,  String reply,  String userId,  String nickName,  String nickImage,  int savedAt,  List<String> folders,  String memo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostSnapshot() when $default != null:
return $default(_that.siteType,_that.id,_that.title,_that.url,_that.board,_that.boardTitle,_that.info,_that.time,_that.reply,_that.userId,_that.nickName,_that.nickImage,_that.savedAt,_that.folders,_that.memo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SiteType siteType,  int id,  String title,  String url,  String board,  String boardTitle,  String info,  String time,  String reply,  String userId,  String nickName,  String nickImage,  int savedAt,  List<String> folders,  String memo)  $default,) {final _that = this;
switch (_that) {
case _PostSnapshot():
return $default(_that.siteType,_that.id,_that.title,_that.url,_that.board,_that.boardTitle,_that.info,_that.time,_that.reply,_that.userId,_that.nickName,_that.nickImage,_that.savedAt,_that.folders,_that.memo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SiteType siteType,  int id,  String title,  String url,  String board,  String boardTitle,  String info,  String time,  String reply,  String userId,  String nickName,  String nickImage,  int savedAt,  List<String> folders,  String memo)?  $default,) {final _that = this;
switch (_that) {
case _PostSnapshot() when $default != null:
return $default(_that.siteType,_that.id,_that.title,_that.url,_that.board,_that.boardTitle,_that.info,_that.time,_that.reply,_that.userId,_that.nickName,_that.nickImage,_that.savedAt,_that.folders,_that.memo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostSnapshot extends PostSnapshot {
  const _PostSnapshot({required this.siteType, required this.id, required this.title, required this.url, required this.board, required this.boardTitle, required this.info, required this.time, required this.reply, required this.userId, required this.nickName, required this.nickImage, required this.savedAt,  List<String> folders = const <String>[], this.memo = ''}): _folders = folders,super._();
  factory _PostSnapshot.fromJson(Map<String, dynamic> json) => _$PostSnapshotFromJson(json);

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
/// 스크랩 폴더 id(`BookmarkFolder.id`). 한 글을 여러 폴더에 넣을 수 있다. 스크랩에서만 쓴다.
 final  List<String> _folders;
/// 스크랩 폴더 id(`BookmarkFolder.id`). 한 글을 여러 폴더에 넣을 수 있다. 스크랩에서만 쓴다.
@override@JsonKey() List<String> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}

/// 스크랩에 붙인 한 줄 메모. 스크랩에서만 쓴다.
@override@JsonKey() final  String memo;

/// Create a copy of PostSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostSnapshotCopyWith<_PostSnapshot> get copyWith => __$PostSnapshotCopyWithImpl<_PostSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostSnapshot&&(identical(other.siteType, siteType) || other.siteType == siteType)&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.board, board) || other.board == board)&&(identical(other.boardTitle, boardTitle) || other.boardTitle == boardTitle)&&(identical(other.info, info) || other.info == info)&&(identical(other.time, time) || other.time == time)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickName, nickName) || other.nickName == nickName)&&(identical(other.nickImage, nickImage) || other.nickImage == nickImage)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&const DeepCollectionEquality().equals(other.folders, _folders)&&(identical(other.memo, memo) || other.memo == memo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,siteType,id,title,url,board,boardTitle,info,time,reply,userId,nickName,nickImage,savedAt,const DeepCollectionEquality().hash(_folders),memo);
}

@override
String toString() {
    return 'PostSnapshot(siteType: $siteType, id: $id, title: $title, url: $url, board: $board, boardTitle: $boardTitle, info: $info, time: $time, reply: $reply, userId: $userId, nickName: $nickName, nickImage: $nickImage, savedAt: $savedAt, folders: $folders, memo: $memo)';
}


}

/// @nodoc
abstract mixin class _$PostSnapshotCopyWith<$Res> implements $PostSnapshotCopyWith<$Res> {
  factory _$PostSnapshotCopyWith(_PostSnapshot value, $Res Function(_PostSnapshot) _then) = __$PostSnapshotCopyWithImpl;
@override @useResult
$Res call({
 SiteType siteType, int id, String title, String url, String board, String boardTitle, String info, String time, String reply, String userId, String nickName, String nickImage, int savedAt, List<String> folders, String memo
});




}
/// @nodoc
class __$PostSnapshotCopyWithImpl<$Res>
    implements _$PostSnapshotCopyWith<$Res> {
  __$PostSnapshotCopyWithImpl(this._self, this._then);

  final _PostSnapshot _self;
  final $Res Function(_PostSnapshot) _then;

/// Create a copy of PostSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteType = null,Object? id = null,Object? title = null,Object? url = null,Object? board = null,Object? boardTitle = null,Object? info = null,Object? time = null,Object? reply = null,Object? userId = null,Object? nickName = null,Object? nickImage = null,Object? savedAt = null,Object? folders = null,Object? memo = null,}) {
  return _then(_PostSnapshot(
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
as int,folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<String>,memo: null == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
