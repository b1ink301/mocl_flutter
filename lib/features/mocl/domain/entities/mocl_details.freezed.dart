// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Details {
  String get title => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get viewCount => throw _privateConstructorUsedError;
  String get likeCount => throw _privateConstructorUsedError;
  String get bodyHtml => throw _privateConstructorUsedError;
  String get csrf => throw _privateConstructorUsedError;
  UserInfo get userInfo => throw _privateConstructorUsedError;
  List<DetailItem> get bodies => throw _privateConstructorUsedError;
  List<CommentItem> get comments => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DetailsCopyWith<Details> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailsCopyWith<$Res> {
  factory $DetailsCopyWith(Details value, $Res Function(Details) then) =
      _$DetailsCopyWithImpl<$Res, Details>;
  @useResult
  $Res call(
      {String title,
      String time,
      String viewCount,
      String likeCount,
      String bodyHtml,
      String csrf,
      UserInfo userInfo,
      List<DetailItem> bodies,
      List<CommentItem> comments});
}

/// @nodoc
class _$DetailsCopyWithImpl<$Res, $Val extends Details>
    implements $DetailsCopyWith<$Res> {
  _$DetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? time = null,
    Object? viewCount = null,
    Object? likeCount = null,
    Object? bodyHtml = null,
    Object? csrf = null,
    Object? userInfo = null,
    Object? bodies = null,
    Object? comments = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as String,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as String,
      bodyHtml: null == bodyHtml
          ? _value.bodyHtml
          : bodyHtml // ignore: cast_nullable_to_non_nullable
              as String,
      csrf: null == csrf
          ? _value.csrf
          : csrf // ignore: cast_nullable_to_non_nullable
              as String,
      userInfo: null == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo,
      bodies: null == bodies
          ? _value.bodies
          : bodies // ignore: cast_nullable_to_non_nullable
              as List<DetailItem>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DetailsImplCopyWith<$Res> implements $DetailsCopyWith<$Res> {
  factory _$$DetailsImplCopyWith(
          _$DetailsImpl value, $Res Function(_$DetailsImpl) then) =
      __$$DetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String time,
      String viewCount,
      String likeCount,
      String bodyHtml,
      String csrf,
      UserInfo userInfo,
      List<DetailItem> bodies,
      List<CommentItem> comments});
}

/// @nodoc
class __$$DetailsImplCopyWithImpl<$Res>
    extends _$DetailsCopyWithImpl<$Res, _$DetailsImpl>
    implements _$$DetailsImplCopyWith<$Res> {
  __$$DetailsImplCopyWithImpl(
      _$DetailsImpl _value, $Res Function(_$DetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? time = null,
    Object? viewCount = null,
    Object? likeCount = null,
    Object? bodyHtml = null,
    Object? csrf = null,
    Object? userInfo = null,
    Object? bodies = null,
    Object? comments = null,
  }) {
    return _then(_$DetailsImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as String,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as String,
      bodyHtml: null == bodyHtml
          ? _value.bodyHtml
          : bodyHtml // ignore: cast_nullable_to_non_nullable
              as String,
      csrf: null == csrf
          ? _value.csrf
          : csrf // ignore: cast_nullable_to_non_nullable
              as String,
      userInfo: null == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo,
      bodies: null == bodies
          ? _value._bodies
          : bodies // ignore: cast_nullable_to_non_nullable
              as List<DetailItem>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentItem>,
    ));
  }
}

/// @nodoc

class _$DetailsImpl implements _Details {
  const _$DetailsImpl(
      {required this.title,
      required this.time,
      required this.viewCount,
      required this.likeCount,
      required this.bodyHtml,
      required this.csrf,
      required this.userInfo,
      required final List<DetailItem> bodies,
      required final List<CommentItem> comments})
      : _bodies = bodies,
        _comments = comments;

  @override
  final String title;
  @override
  final String time;
  @override
  final String viewCount;
  @override
  final String likeCount;
  @override
  final String bodyHtml;
  @override
  final String csrf;
  @override
  final UserInfo userInfo;
  final List<DetailItem> _bodies;
  @override
  List<DetailItem> get bodies {
    if (_bodies is EqualUnmodifiableListView) return _bodies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bodies);
  }

  final List<CommentItem> _comments;
  @override
  List<CommentItem> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  String toString() {
    return 'Details(title: $title, time: $time, viewCount: $viewCount, likeCount: $likeCount, bodyHtml: $bodyHtml, csrf: $csrf, userInfo: $userInfo, bodies: $bodies, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailsImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.bodyHtml, bodyHtml) ||
                other.bodyHtml == bodyHtml) &&
            (identical(other.csrf, csrf) || other.csrf == csrf) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            const DeepCollectionEquality().equals(other._bodies, _bodies) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      time,
      viewCount,
      likeCount,
      bodyHtml,
      csrf,
      userInfo,
      const DeepCollectionEquality().hash(_bodies),
      const DeepCollectionEquality().hash(_comments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailsImplCopyWith<_$DetailsImpl> get copyWith =>
      __$$DetailsImplCopyWithImpl<_$DetailsImpl>(this, _$identity);
}

abstract class _Details implements Details {
  const factory _Details(
      {required final String title,
      required final String time,
      required final String viewCount,
      required final String likeCount,
      required final String bodyHtml,
      required final String csrf,
      required final UserInfo userInfo,
      required final List<DetailItem> bodies,
      required final List<CommentItem> comments}) = _$DetailsImpl;

  @override
  String get title;
  @override
  String get time;
  @override
  String get viewCount;
  @override
  String get likeCount;
  @override
  String get bodyHtml;
  @override
  String get csrf;
  @override
  UserInfo get userInfo;
  @override
  List<DetailItem> get bodies;
  @override
  List<CommentItem> get comments;
  @override
  @JsonKey(ignore: true)
  _$$DetailsImplCopyWith<_$DetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
