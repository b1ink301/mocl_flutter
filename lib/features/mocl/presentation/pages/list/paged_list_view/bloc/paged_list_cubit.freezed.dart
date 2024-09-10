// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paged_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PagedListState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadingPage,
    required TResult Function(List<ReadableListItem> list, int page) nextPage,
    required TResult Function(String message, int page) errorPage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadingPage,
    TResult? Function(List<ReadableListItem> list, int page)? nextPage,
    TResult? Function(String message, int page)? errorPage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadingPage,
    TResult Function(List<ReadableListItem> list, int page)? nextPage,
    TResult Function(String message, int page)? errorPage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingPage value) loadingPage,
    required TResult Function(NextPage value) nextPage,
    required TResult Function(ErrorPage value) errorPage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingPage value)? loadingPage,
    TResult? Function(NextPage value)? nextPage,
    TResult? Function(ErrorPage value)? errorPage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingPage value)? loadingPage,
    TResult Function(NextPage value)? nextPage,
    TResult Function(ErrorPage value)? errorPage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagedListStateCopyWith<$Res> {
  factory $PagedListStateCopyWith(
          PagedListState value, $Res Function(PagedListState) then) =
      _$PagedListStateCopyWithImpl<$Res, PagedListState>;
}

/// @nodoc
class _$PagedListStateCopyWithImpl<$Res, $Val extends PagedListState>
    implements $PagedListStateCopyWith<$Res> {
  _$PagedListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PagedListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadingPageImplCopyWith<$Res> {
  factory _$$LoadingPageImplCopyWith(
          _$LoadingPageImpl value, $Res Function(_$LoadingPageImpl) then) =
      __$$LoadingPageImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingPageImplCopyWithImpl<$Res>
    extends _$PagedListStateCopyWithImpl<$Res, _$LoadingPageImpl>
    implements _$$LoadingPageImplCopyWith<$Res> {
  __$$LoadingPageImplCopyWithImpl(
      _$LoadingPageImpl _value, $Res Function(_$LoadingPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of PagedListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingPageImpl implements LoadingPage {
  const _$LoadingPageImpl();

  @override
  String toString() {
    return 'PagedListState.loadingPage()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingPageImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadingPage,
    required TResult Function(List<ReadableListItem> list, int page) nextPage,
    required TResult Function(String message, int page) errorPage,
  }) {
    return loadingPage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadingPage,
    TResult? Function(List<ReadableListItem> list, int page)? nextPage,
    TResult? Function(String message, int page)? errorPage,
  }) {
    return loadingPage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadingPage,
    TResult Function(List<ReadableListItem> list, int page)? nextPage,
    TResult Function(String message, int page)? errorPage,
    required TResult orElse(),
  }) {
    if (loadingPage != null) {
      return loadingPage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingPage value) loadingPage,
    required TResult Function(NextPage value) nextPage,
    required TResult Function(ErrorPage value) errorPage,
  }) {
    return loadingPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingPage value)? loadingPage,
    TResult? Function(NextPage value)? nextPage,
    TResult? Function(ErrorPage value)? errorPage,
  }) {
    return loadingPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingPage value)? loadingPage,
    TResult Function(NextPage value)? nextPage,
    TResult Function(ErrorPage value)? errorPage,
    required TResult orElse(),
  }) {
    if (loadingPage != null) {
      return loadingPage(this);
    }
    return orElse();
  }
}

abstract class LoadingPage implements PagedListState {
  const factory LoadingPage() = _$LoadingPageImpl;
}

/// @nodoc
abstract class _$$NextPageImplCopyWith<$Res> {
  factory _$$NextPageImplCopyWith(
          _$NextPageImpl value, $Res Function(_$NextPageImpl) then) =
      __$$NextPageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ReadableListItem> list, int page});
}

/// @nodoc
class __$$NextPageImplCopyWithImpl<$Res>
    extends _$PagedListStateCopyWithImpl<$Res, _$NextPageImpl>
    implements _$$NextPageImplCopyWith<$Res> {
  __$$NextPageImplCopyWithImpl(
      _$NextPageImpl _value, $Res Function(_$NextPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of PagedListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? page = null,
  }) {
    return _then(_$NextPageImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ReadableListItem>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$NextPageImpl implements NextPage {
  const _$NextPageImpl(
      {required final List<ReadableListItem> list, required this.page})
      : _list = list;

  final List<ReadableListItem> _list;
  @override
  List<ReadableListItem> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  final int page;

  @override
  String toString() {
    return 'PagedListState.nextPage(list: $list, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextPageImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_list), page);

  /// Create a copy of PagedListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NextPageImplCopyWith<_$NextPageImpl> get copyWith =>
      __$$NextPageImplCopyWithImpl<_$NextPageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadingPage,
    required TResult Function(List<ReadableListItem> list, int page) nextPage,
    required TResult Function(String message, int page) errorPage,
  }) {
    return nextPage(list, page);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadingPage,
    TResult? Function(List<ReadableListItem> list, int page)? nextPage,
    TResult? Function(String message, int page)? errorPage,
  }) {
    return nextPage?.call(list, page);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadingPage,
    TResult Function(List<ReadableListItem> list, int page)? nextPage,
    TResult Function(String message, int page)? errorPage,
    required TResult orElse(),
  }) {
    if (nextPage != null) {
      return nextPage(list, page);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingPage value) loadingPage,
    required TResult Function(NextPage value) nextPage,
    required TResult Function(ErrorPage value) errorPage,
  }) {
    return nextPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingPage value)? loadingPage,
    TResult? Function(NextPage value)? nextPage,
    TResult? Function(ErrorPage value)? errorPage,
  }) {
    return nextPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingPage value)? loadingPage,
    TResult Function(NextPage value)? nextPage,
    TResult Function(ErrorPage value)? errorPage,
    required TResult orElse(),
  }) {
    if (nextPage != null) {
      return nextPage(this);
    }
    return orElse();
  }
}

abstract class NextPage implements PagedListState {
  const factory NextPage(
      {required final List<ReadableListItem> list,
      required final int page}) = _$NextPageImpl;

  List<ReadableListItem> get list;
  int get page;

  /// Create a copy of PagedListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NextPageImplCopyWith<_$NextPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorPageImplCopyWith<$Res> {
  factory _$$ErrorPageImplCopyWith(
          _$ErrorPageImpl value, $Res Function(_$ErrorPageImpl) then) =
      __$$ErrorPageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, int page});
}

/// @nodoc
class __$$ErrorPageImplCopyWithImpl<$Res>
    extends _$PagedListStateCopyWithImpl<$Res, _$ErrorPageImpl>
    implements _$$ErrorPageImplCopyWith<$Res> {
  __$$ErrorPageImplCopyWithImpl(
      _$ErrorPageImpl _value, $Res Function(_$ErrorPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of PagedListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? page = null,
  }) {
    return _then(_$ErrorPageImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ErrorPageImpl implements ErrorPage {
  const _$ErrorPageImpl({required this.message, required this.page});

  @override
  final String message;
  @override
  final int page;

  @override
  String toString() {
    return 'PagedListState.errorPage(message: $message, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorPageImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, page);

  /// Create a copy of PagedListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorPageImplCopyWith<_$ErrorPageImpl> get copyWith =>
      __$$ErrorPageImplCopyWithImpl<_$ErrorPageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadingPage,
    required TResult Function(List<ReadableListItem> list, int page) nextPage,
    required TResult Function(String message, int page) errorPage,
  }) {
    return errorPage(message, page);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadingPage,
    TResult? Function(List<ReadableListItem> list, int page)? nextPage,
    TResult? Function(String message, int page)? errorPage,
  }) {
    return errorPage?.call(message, page);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadingPage,
    TResult Function(List<ReadableListItem> list, int page)? nextPage,
    TResult Function(String message, int page)? errorPage,
    required TResult orElse(),
  }) {
    if (errorPage != null) {
      return errorPage(message, page);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingPage value) loadingPage,
    required TResult Function(NextPage value) nextPage,
    required TResult Function(ErrorPage value) errorPage,
  }) {
    return errorPage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingPage value)? loadingPage,
    TResult? Function(NextPage value)? nextPage,
    TResult? Function(ErrorPage value)? errorPage,
  }) {
    return errorPage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingPage value)? loadingPage,
    TResult Function(NextPage value)? nextPage,
    TResult Function(ErrorPage value)? errorPage,
    required TResult orElse(),
  }) {
    if (errorPage != null) {
      return errorPage(this);
    }
    return orElse();
  }
}

abstract class ErrorPage implements PagedListState {
  const factory ErrorPage(
      {required final String message,
      required final int page}) = _$ErrorPageImpl;

  String get message;
  int get page;

  /// Create a copy of PagedListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorPageImplCopyWith<_$ErrorPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
