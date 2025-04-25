// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListItem implements DiagnosticableTreeMixin {
  int get id;
  String get title;
  String get reply;
  String get category;
  String get time;
  String get url;
  String get info;
  String get board;
  String get boardTitle;
  String get like;
  String get hit;
  UserInfo get userInfo;
  bool get hasImage;
  bool get isRead;

  /// Create a copy of ListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListItemCopyWith<ListItem> get copyWith =>
      _$ListItemCopyWithImpl<ListItem>(this as ListItem, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ListItem'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('reply', reply))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('info', info))
      ..add(DiagnosticsProperty('board', board))
      ..add(DiagnosticsProperty('boardTitle', boardTitle))
      ..add(DiagnosticsProperty('like', like))
      ..add(DiagnosticsProperty('hit', hit))
      ..add(DiagnosticsProperty('userInfo', userInfo))
      ..add(DiagnosticsProperty('hasImage', hasImage))
      ..add(DiagnosticsProperty('isRead', isRead));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.info, info) || other.info == info) &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.boardTitle, boardTitle) ||
                other.boardTitle == boardTitle) &&
            (identical(other.like, like) || other.like == like) &&
            (identical(other.hit, hit) || other.hit == hit) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.hasImage, hasImage) ||
                other.hasImage == hasImage) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, reply, category, time,
      url, info, board, boardTitle, like, hit, userInfo, hasImage, isRead);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ListItem(id: $id, title: $title, reply: $reply, category: $category, time: $time, url: $url, info: $info, board: $board, boardTitle: $boardTitle, like: $like, hit: $hit, userInfo: $userInfo, hasImage: $hasImage, isRead: $isRead)';
  }
}

/// @nodoc
abstract mixin class $ListItemCopyWith<$Res> {
  factory $ListItemCopyWith(ListItem value, $Res Function(ListItem) _then) =
      _$ListItemCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      String reply,
      String category,
      String time,
      String url,
      String info,
      String board,
      String boardTitle,
      String like,
      String hit,
      UserInfo userInfo,
      bool hasImage,
      bool isRead});

  $UserInfoCopyWith<$Res> get userInfo;
}

/// @nodoc
class _$ListItemCopyWithImpl<$Res> implements $ListItemCopyWith<$Res> {
  _$ListItemCopyWithImpl(this._self, this._then);

  final ListItem _self;
  final $Res Function(ListItem) _then;

  /// Create a copy of ListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? reply = null,
    Object? category = null,
    Object? time = null,
    Object? url = null,
    Object? info = null,
    Object? board = null,
    Object? boardTitle = null,
    Object? like = null,
    Object? hit = null,
    Object? userInfo = null,
    Object? hasImage = null,
    Object? isRead = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reply: null == reply
          ? _self.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      info: null == info
          ? _self.info
          : info // ignore: cast_nullable_to_non_nullable
              as String,
      board: null == board
          ? _self.board
          : board // ignore: cast_nullable_to_non_nullable
              as String,
      boardTitle: null == boardTitle
          ? _self.boardTitle
          : boardTitle // ignore: cast_nullable_to_non_nullable
              as String,
      like: null == like
          ? _self.like
          : like // ignore: cast_nullable_to_non_nullable
              as String,
      hit: null == hit
          ? _self.hit
          : hit // ignore: cast_nullable_to_non_nullable
              as String,
      userInfo: null == userInfo
          ? _self.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo,
      hasImage: null == hasImage
          ? _self.hasImage
          : hasImage // ignore: cast_nullable_to_non_nullable
              as bool,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
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

/// @nodoc

class _ListItem with DiagnosticableTreeMixin implements ListItem {
  const _ListItem(
      {required this.id,
      required this.title,
      required this.reply,
      required this.category,
      required this.time,
      required this.url,
      required this.info,
      required this.board,
      required this.boardTitle,
      required this.like,
      required this.hit,
      required this.userInfo,
      required this.hasImage,
      required this.isRead});

  @override
  final int id;
  @override
  final String title;
  @override
  final String reply;
  @override
  final String category;
  @override
  final String time;
  @override
  final String url;
  @override
  final String info;
  @override
  final String board;
  @override
  final String boardTitle;
  @override
  final String like;
  @override
  final String hit;
  @override
  final UserInfo userInfo;
  @override
  final bool hasImage;
  @override
  final bool isRead;

  /// Create a copy of ListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ListItemCopyWith<_ListItem> get copyWith =>
      __$ListItemCopyWithImpl<_ListItem>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ListItem'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('reply', reply))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('info', info))
      ..add(DiagnosticsProperty('board', board))
      ..add(DiagnosticsProperty('boardTitle', boardTitle))
      ..add(DiagnosticsProperty('like', like))
      ..add(DiagnosticsProperty('hit', hit))
      ..add(DiagnosticsProperty('userInfo', userInfo))
      ..add(DiagnosticsProperty('hasImage', hasImage))
      ..add(DiagnosticsProperty('isRead', isRead));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ListItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.info, info) || other.info == info) &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.boardTitle, boardTitle) ||
                other.boardTitle == boardTitle) &&
            (identical(other.like, like) || other.like == like) &&
            (identical(other.hit, hit) || other.hit == hit) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.hasImage, hasImage) ||
                other.hasImage == hasImage) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, reply, category, time,
      url, info, board, boardTitle, like, hit, userInfo, hasImage, isRead);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ListItem(id: $id, title: $title, reply: $reply, category: $category, time: $time, url: $url, info: $info, board: $board, boardTitle: $boardTitle, like: $like, hit: $hit, userInfo: $userInfo, hasImage: $hasImage, isRead: $isRead)';
  }
}

/// @nodoc
abstract mixin class _$ListItemCopyWith<$Res>
    implements $ListItemCopyWith<$Res> {
  factory _$ListItemCopyWith(_ListItem value, $Res Function(_ListItem) _then) =
      __$ListItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String reply,
      String category,
      String time,
      String url,
      String info,
      String board,
      String boardTitle,
      String like,
      String hit,
      UserInfo userInfo,
      bool hasImage,
      bool isRead});

  @override
  $UserInfoCopyWith<$Res> get userInfo;
}

/// @nodoc
class __$ListItemCopyWithImpl<$Res> implements _$ListItemCopyWith<$Res> {
  __$ListItemCopyWithImpl(this._self, this._then);

  final _ListItem _self;
  final $Res Function(_ListItem) _then;

  /// Create a copy of ListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? reply = null,
    Object? category = null,
    Object? time = null,
    Object? url = null,
    Object? info = null,
    Object? board = null,
    Object? boardTitle = null,
    Object? like = null,
    Object? hit = null,
    Object? userInfo = null,
    Object? hasImage = null,
    Object? isRead = null,
  }) {
    return _then(_ListItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reply: null == reply
          ? _self.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      info: null == info
          ? _self.info
          : info // ignore: cast_nullable_to_non_nullable
              as String,
      board: null == board
          ? _self.board
          : board // ignore: cast_nullable_to_non_nullable
              as String,
      boardTitle: null == boardTitle
          ? _self.boardTitle
          : boardTitle // ignore: cast_nullable_to_non_nullable
              as String,
      like: null == like
          ? _self.like
          : like // ignore: cast_nullable_to_non_nullable
              as String,
      hit: null == hit
          ? _self.hit
          : hit // ignore: cast_nullable_to_non_nullable
              as String,
      userInfo: null == userInfo
          ? _self.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo,
      hasImage: null == hasImage
          ? _self.hasImage
          : hasImage // ignore: cast_nullable_to_non_nullable
              as bool,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
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
