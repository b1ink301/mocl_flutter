// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mocl_recents.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Recents {
  List<Recent> get articles;
  List<Recent> get comments;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecentsCopyWith<Recents> get copyWith =>
      _$RecentsCopyWithImpl<Recents>(this as Recents, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Recents &&
            const DeepCollectionEquality().equals(other.articles, articles) &&
            const DeepCollectionEquality().equals(other.comments, comments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(articles),
      const DeepCollectionEquality().hash(comments));

  @override
  String toString() {
    return 'Recents(articles: $articles, comments: $comments)';
  }
}

/// @nodoc
abstract mixin class $RecentsCopyWith<$Res> {
  factory $RecentsCopyWith(Recents value, $Res Function(Recents) _then) =
      _$RecentsCopyWithImpl;
  @useResult
  $Res call({List<Recent> articles, List<Recent> comments});
}

/// @nodoc
class _$RecentsCopyWithImpl<$Res> implements $RecentsCopyWith<$Res> {
  _$RecentsCopyWithImpl(this._self, this._then);

  final Recents _self;
  final $Res Function(Recents) _then;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articles = null,
    Object? comments = null,
  }) {
    return _then(_self.copyWith(
      articles: null == articles
          ? _self.articles
          : articles // ignore: cast_nullable_to_non_nullable
              as List<Recent>,
      comments: null == comments
          ? _self.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Recent>,
    ));
  }
}

/// @nodoc

class _Recents implements Recents {
  const _Recents(
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

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecentsCopyWith<_Recents> get copyWith =>
      __$RecentsCopyWithImpl<_Recents>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Recents &&
            const DeepCollectionEquality().equals(other._articles, _articles) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_articles),
      const DeepCollectionEquality().hash(_comments));

  @override
  String toString() {
    return 'Recents(articles: $articles, comments: $comments)';
  }
}

/// @nodoc
abstract mixin class _$RecentsCopyWith<$Res> implements $RecentsCopyWith<$Res> {
  factory _$RecentsCopyWith(_Recents value, $Res Function(_Recents) _then) =
      __$RecentsCopyWithImpl;
  @override
  @useResult
  $Res call({List<Recent> articles, List<Recent> comments});
}

/// @nodoc
class __$RecentsCopyWithImpl<$Res> implements _$RecentsCopyWith<$Res> {
  __$RecentsCopyWithImpl(this._self, this._then);

  final _Recents _self;
  final $Res Function(_Recents) _then;

  /// Create a copy of Recents
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? articles = null,
    Object? comments = null,
  }) {
    return _then(_Recents(
      articles: null == articles
          ? _self._articles
          : articles // ignore: cast_nullable_to_non_nullable
              as List<Recent>,
      comments: null == comments
          ? _self._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Recent>,
    ));
  }
}

/// @nodoc
mixin _$Recent {
  String get title;
  String get time;
  Map<String, dynamic> get extraData;

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecentCopyWith<Recent> get copyWith =>
      _$RecentCopyWithImpl<Recent>(this as Recent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Recent &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.time, time) || other.time == time) &&
            const DeepCollectionEquality().equals(other.extraData, extraData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, time, const DeepCollectionEquality().hash(extraData));

  @override
  String toString() {
    return 'Recent(title: $title, time: $time, extraData: $extraData)';
  }
}

/// @nodoc
abstract mixin class $RecentCopyWith<$Res> {
  factory $RecentCopyWith(Recent value, $Res Function(Recent) _then) =
      _$RecentCopyWithImpl;
  @useResult
  $Res call({String title, String time, Map<String, dynamic> extraData});
}

/// @nodoc
class _$RecentCopyWithImpl<$Res> implements $RecentCopyWith<$Res> {
  _$RecentCopyWithImpl(this._self, this._then);

  final Recent _self;
  final $Res Function(Recent) _then;

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? time = null,
    Object? extraData = null,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      extraData: null == extraData
          ? _self.extraData
          : extraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _Recent implements Recent {
  const _Recent(
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

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecentCopyWith<_Recent> get copyWith =>
      __$RecentCopyWithImpl<_Recent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Recent &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.time, time) || other.time == time) &&
            const DeepCollectionEquality()
                .equals(other._extraData, _extraData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, time,
      const DeepCollectionEquality().hash(_extraData));

  @override
  String toString() {
    return 'Recent(title: $title, time: $time, extraData: $extraData)';
  }
}

/// @nodoc
abstract mixin class _$RecentCopyWith<$Res> implements $RecentCopyWith<$Res> {
  factory _$RecentCopyWith(_Recent value, $Res Function(_Recent) _then) =
      __$RecentCopyWithImpl;
  @override
  @useResult
  $Res call({String title, String time, Map<String, dynamic> extraData});
}

/// @nodoc
class __$RecentCopyWithImpl<$Res> implements _$RecentCopyWith<$Res> {
  __$RecentCopyWithImpl(this._self, this._then);

  final _Recent _self;
  final $Res Function(_Recent) _then;

  /// Create a copy of Recent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? time = null,
    Object? extraData = null,
  }) {
    return _then(_Recent(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      extraData: null == extraData
          ? _self._extraData
          : extraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
