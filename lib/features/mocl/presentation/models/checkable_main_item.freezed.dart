// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkable_main_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CheckableMainItem {
  MainItem get mainItem => throw _privateConstructorUsedError;
  bool get isChecked => throw _privateConstructorUsedError;

  /// Create a copy of CheckableMainItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckableMainItemCopyWith<CheckableMainItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckableMainItemCopyWith<$Res> {
  factory $CheckableMainItemCopyWith(
          CheckableMainItem value, $Res Function(CheckableMainItem) then) =
      _$CheckableMainItemCopyWithImpl<$Res, CheckableMainItem>;
  @useResult
  $Res call({MainItem mainItem, bool isChecked});

  $MainItemCopyWith<$Res> get mainItem;
}

/// @nodoc
class _$CheckableMainItemCopyWithImpl<$Res, $Val extends CheckableMainItem>
    implements $CheckableMainItemCopyWith<$Res> {
  _$CheckableMainItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckableMainItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mainItem = null,
    Object? isChecked = null,
  }) {
    return _then(_value.copyWith(
      mainItem: null == mainItem
          ? _value.mainItem
          : mainItem // ignore: cast_nullable_to_non_nullable
              as MainItem,
      isChecked: null == isChecked
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of CheckableMainItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MainItemCopyWith<$Res> get mainItem {
    return $MainItemCopyWith<$Res>(_value.mainItem, (value) {
      return _then(_value.copyWith(mainItem: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckableMainItemImplCopyWith<$Res>
    implements $CheckableMainItemCopyWith<$Res> {
  factory _$$CheckableMainItemImplCopyWith(_$CheckableMainItemImpl value,
          $Res Function(_$CheckableMainItemImpl) then) =
      __$$CheckableMainItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MainItem mainItem, bool isChecked});

  @override
  $MainItemCopyWith<$Res> get mainItem;
}

/// @nodoc
class __$$CheckableMainItemImplCopyWithImpl<$Res>
    extends _$CheckableMainItemCopyWithImpl<$Res, _$CheckableMainItemImpl>
    implements _$$CheckableMainItemImplCopyWith<$Res> {
  __$$CheckableMainItemImplCopyWithImpl(_$CheckableMainItemImpl _value,
      $Res Function(_$CheckableMainItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckableMainItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mainItem = null,
    Object? isChecked = null,
  }) {
    return _then(_$CheckableMainItemImpl(
      mainItem: null == mainItem
          ? _value.mainItem
          : mainItem // ignore: cast_nullable_to_non_nullable
              as MainItem,
      isChecked: null == isChecked
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CheckableMainItemImpl implements _CheckableMainItem {
  _$CheckableMainItemImpl({required this.mainItem, required this.isChecked});

  @override
  final MainItem mainItem;
  @override
  final bool isChecked;

  @override
  String toString() {
    return 'CheckableMainItem(mainItem: $mainItem, isChecked: $isChecked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckableMainItemImpl &&
            (identical(other.mainItem, mainItem) ||
                other.mainItem == mainItem) &&
            (identical(other.isChecked, isChecked) ||
                other.isChecked == isChecked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mainItem, isChecked);

  /// Create a copy of CheckableMainItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckableMainItemImplCopyWith<_$CheckableMainItemImpl> get copyWith =>
      __$$CheckableMainItemImplCopyWithImpl<_$CheckableMainItemImpl>(
          this, _$identity);
}

abstract class _CheckableMainItem implements CheckableMainItem {
  factory _CheckableMainItem(
      {required final MainItem mainItem,
      required final bool isChecked}) = _$CheckableMainItemImpl;

  @override
  MainItem get mainItem;
  @override
  bool get isChecked;

  /// Create a copy of CheckableMainItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckableMainItemImplCopyWith<_$CheckableMainItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
