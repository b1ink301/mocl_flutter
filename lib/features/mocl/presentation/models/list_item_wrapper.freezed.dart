// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_item_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ListItemWrapper {
  ListItem get item => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;

  /// Create a copy of ListItemWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListItemWrapperCopyWith<ListItemWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListItemWrapperCopyWith<$Res> {
  factory $ListItemWrapperCopyWith(
          ListItemWrapper value, $Res Function(ListItemWrapper) then) =
      _$ListItemWrapperCopyWithImpl<$Res, ListItemWrapper>;
  @useResult
  $Res call({ListItem item, double height});

  $ListItemCopyWith<$Res> get item;
}

/// @nodoc
class _$ListItemWrapperCopyWithImpl<$Res, $Val extends ListItemWrapper>
    implements $ListItemWrapperCopyWith<$Res> {
  _$ListItemWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListItemWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as ListItem,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of ListItemWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ListItemCopyWith<$Res> get item {
    return $ListItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ListItemWrapperImplCopyWith<$Res>
    implements $ListItemWrapperCopyWith<$Res> {
  factory _$$ListItemWrapperImplCopyWith(_$ListItemWrapperImpl value,
          $Res Function(_$ListItemWrapperImpl) then) =
      __$$ListItemWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ListItem item, double height});

  @override
  $ListItemCopyWith<$Res> get item;
}

/// @nodoc
class __$$ListItemWrapperImplCopyWithImpl<$Res>
    extends _$ListItemWrapperCopyWithImpl<$Res, _$ListItemWrapperImpl>
    implements _$$ListItemWrapperImplCopyWith<$Res> {
  __$$ListItemWrapperImplCopyWithImpl(
      _$ListItemWrapperImpl _value, $Res Function(_$ListItemWrapperImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListItemWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? height = null,
  }) {
    return _then(_$ListItemWrapperImpl(
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as ListItem,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ListItemWrapperImpl implements _ListItemWrapper {
  _$ListItemWrapperImpl({required this.item, required this.height});

  @override
  final ListItem item;
  @override
  final double height;

  @override
  String toString() {
    return 'ListItemWrapper(item: $item, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListItemWrapperImpl &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.height, height) || other.height == height));
  }

  @override
  int get hashCode => Object.hash(runtimeType, item, height);

  /// Create a copy of ListItemWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListItemWrapperImplCopyWith<_$ListItemWrapperImpl> get copyWith =>
      __$$ListItemWrapperImplCopyWithImpl<_$ListItemWrapperImpl>(
          this, _$identity);
}

abstract class _ListItemWrapper implements ListItemWrapper {
  factory _ListItemWrapper(
      {required final ListItem item,
      required final double height}) = _$ListItemWrapperImpl;

  @override
  ListItem get item;
  @override
  double get height;

  /// Create a copy of ListItemWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListItemWrapperImplCopyWith<_$ListItemWrapperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
