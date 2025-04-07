// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_recents.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Recents {
  List<Recent> get articles => throw _privateConstructorUsedError;
  List<Recent> get comments => throw _privateConstructorUsedError;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentsCopyWith<Recents> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentsCopyWith<$Res> {
  factory $RecentsCopyWith(Recents value, $Res Function(Recents) then) =
      _$RecentsCopyWithImpl<$Res, Recents>;
  @useResult
  $Res call({List<Recent> articles, List<Recent> comments});
}

/// @nodoc
class _$RecentsCopyWithImpl<$Res, $Val extends Recents>
    implements $RecentsCopyWith<$Res> {
  _$RecentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articles = null,
    Object? comments = null,
  }) {
    return _then(_value.copyWith(
      articles: null == articles
          ? _value.articles
          : articles // ignore: cast_nullable_to_non_nullable
              as List<Recent>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Recent>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentsImplCopyWith<$Res> implements $RecentsCopyWith<$Res> {
  factory _$$RecentsImplCopyWith(
          _$RecentsImpl value, $Res Function(_$RecentsImpl) then) =
      __$$RecentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Recent> articles, List<Recent> comments});
}

/// @nodoc
class __$$RecentsImplCopyWithImpl<$Res>
    extends _$RecentsCopyWithImpl<$Res, _$RecentsImpl>
    implements _$$RecentsImplCopyWith<$Res> {
  __$$RecentsImplCopyWithImpl(
      _$RecentsImpl _value, $Res Function(_$RecentsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articles = null,
    Object? comments = null,
  }) {
    return _then(_$RecentsImpl(
      articles: null == articles
          ? _value._articles
          : articles // ignore: cast_nullable_to_non_nullable
              as List<Recent>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Recent>,
    ));
  }
}

/// @nodoc

class _$RecentsImpl implements _Recents {
  const _$RecentsImpl(
      {final List<Recent> articles = const [],
      final List<Recent> comments = const []})
      : _articles = articles,
        _comments = comments;

  final List<Recent> _articles;
  @override
  @JsonKey()
  List<Recent> get articles {
    if (_articles is EqualUnmodifiableListView) return _articles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_articles);
  }

  final List<Recent> _comments;
  @override
  @JsonKey()
  List<Recent> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  String toString() {
    return 'Recents(articles: $articles, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentsImpl &&
            const DeepCollectionEquality().equals(other._articles, _articles) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_articles),
      const DeepCollectionEquality().hash(_comments));

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentsImplCopyWith<_$RecentsImpl> get copyWith =>
      __$$RecentsImplCopyWithImpl<_$RecentsImpl>(this, _$identity);
}

abstract class _Recents implements Recents {
  const factory _Recents(
      {final List<Recent> articles,
      final List<Recent> comments}) = _$RecentsImpl;

  @override
  List<Recent> get articles;
  @override
  List<Recent> get comments;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentsImplCopyWith<_$RecentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Recent {
  String get title => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  Map<String, dynamic> get extraData => throw _privateConstructorUsedError;

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentCopyWith<Recent> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentCopyWith<$Res> {
  factory $RecentCopyWith(Recent value, $Res Function(Recent) then) =
      _$RecentCopyWithImpl<$Res, Recent>;
  @useResult
  $Res call({String title, String time, Map<String, dynamic> extraData});
}

/// @nodoc
class _$RecentCopyWithImpl<$Res, $Val extends Recent>
    implements $RecentCopyWith<$Res> {
  _$RecentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? time = null,
    Object? extraData = null,
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
      extraData: null == extraData
          ? _value.extraData
          : extraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentImplCopyWith<$Res> implements $RecentCopyWith<$Res> {
  factory _$$RecentImplCopyWith(
          _$RecentImpl value, $Res Function(_$RecentImpl) then) =
      __$$RecentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String time, Map<String, dynamic> extraData});
}

/// @nodoc
class __$$RecentImplCopyWithImpl<$Res>
    extends _$RecentCopyWithImpl<$Res, _$RecentImpl>
    implements _$$RecentImplCopyWith<$Res> {
  __$$RecentImplCopyWithImpl(
      _$RecentImpl _value, $Res Function(_$RecentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? time = null,
    Object? extraData = null,
  }) {
    return _then(_$RecentImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      extraData: null == extraData
          ? _value._extraData
          : extraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$RecentImpl implements _Recent {
  const _$RecentImpl(
      {this.title = '',
      this.time = '',
      final Map<String, dynamic> extraData = const {}})
      : _extraData = extraData;

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String time;
  final Map<String, dynamic> _extraData;
  @override
  @JsonKey()
  Map<String, dynamic> get extraData {
    if (_extraData is EqualUnmodifiableMapView) return _extraData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extraData);
  }

  @override
  String toString() {
    return 'Recent(title: $title, time: $time, extraData: $extraData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.time, time) || other.time == time) &&
            const DeepCollectionEquality()
                .equals(other._extraData, _extraData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, time,
      const DeepCollectionEquality().hash(_extraData));

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentImplCopyWith<_$RecentImpl> get copyWith =>
      __$$RecentImplCopyWithImpl<_$RecentImpl>(this, _$identity);
}

abstract class _Recent implements Recent {
  const factory _Recent(
      {final String title,
      final String time,
      final Map<String, dynamic> extraData}) = _$RecentImpl;

  @override
  String get title;
  @override
  String get time;
  @override
  Map<String, dynamic> get extraData;

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentImplCopyWith<_$RecentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
