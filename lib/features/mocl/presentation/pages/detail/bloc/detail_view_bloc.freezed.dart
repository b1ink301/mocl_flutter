// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_view_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailViewEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailViewEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DetailViewEvent()';
}


}

/// @nodoc
class $DetailViewEventCopyWith<$Res>  {
$DetailViewEventCopyWith(DetailViewEvent _, $Res Function(DetailViewEvent) __);
}


/// Adds pattern-matching-related methods to [DetailViewEvent].
extension DetailViewEventPatterns on DetailViewEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DetailsEvent value)?  details,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DetailsEvent() when details != null:
return details(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DetailsEvent value)  details,}){
final _that = this;
switch (_that) {
case DetailsEvent():
return details(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DetailsEvent value)?  details,}){
final _that = this;
switch (_that) {
case DetailsEvent() when details != null:
return details(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  details,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DetailsEvent() when details != null:
return details();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  details,}) {final _that = this;
switch (_that) {
case DetailsEvent():
return details();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  details,}) {final _that = this;
switch (_that) {
case DetailsEvent() when details != null:
return details();case _:
  return null;

}
}

}

/// @nodoc


class DetailsEvent implements DetailViewEvent {
  const DetailsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DetailViewEvent.details()';
}


}




/// @nodoc
mixin _$DetailViewState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailViewState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DetailViewState()';
}


}

/// @nodoc
class $DetailViewStateCopyWith<$Res>  {
$DetailViewStateCopyWith(DetailViewState _, $Res Function(DetailViewState) __);
}


/// Adds pattern-matching-related methods to [DetailViewState].
extension DetailViewStatePatterns on DetailViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DetailLoading value)?  loading,TResult Function( DetailSuccess value)?  success,TResult Function( DetailFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DetailLoading() when loading != null:
return loading(_that);case DetailSuccess() when success != null:
return success(_that);case DetailFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DetailLoading value)  loading,required TResult Function( DetailSuccess value)  success,required TResult Function( DetailFailed value)  failed,}){
final _that = this;
switch (_that) {
case DetailLoading():
return loading(_that);case DetailSuccess():
return success(_that);case DetailFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DetailLoading value)?  loading,TResult? Function( DetailSuccess value)?  success,TResult? Function( DetailFailed value)?  failed,}){
final _that = this;
switch (_that) {
case DetailLoading() when loading != null:
return loading(_that);case DetailSuccess() when success != null:
return success(_that);case DetailFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Details detail)?  success,TResult Function( String message)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DetailLoading() when loading != null:
return loading();case DetailSuccess() when success != null:
return success(_that.detail);case DetailFailed() when failed != null:
return failed(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Details detail)  success,required TResult Function( String message)  failed,}) {final _that = this;
switch (_that) {
case DetailLoading():
return loading();case DetailSuccess():
return success(_that.detail);case DetailFailed():
return failed(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Details detail)?  success,TResult? Function( String message)?  failed,}) {final _that = this;
switch (_that) {
case DetailLoading() when loading != null:
return loading();case DetailSuccess() when success != null:
return success(_that.detail);case DetailFailed() when failed != null:
return failed(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DetailLoading implements DetailViewState {
  const DetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DetailViewState.loading()';
}


}




/// @nodoc


class DetailSuccess implements DetailViewState {
  const DetailSuccess(this.detail);
  

 final  Details detail;

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailSuccessCopyWith<DetailSuccess> get copyWith => _$DetailSuccessCopyWithImpl<DetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailSuccess&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,detail);

@override
String toString() {
  return 'DetailViewState.success(detail: $detail)';
}


}

/// @nodoc
abstract mixin class $DetailSuccessCopyWith<$Res> implements $DetailViewStateCopyWith<$Res> {
  factory $DetailSuccessCopyWith(DetailSuccess value, $Res Function(DetailSuccess) _then) = _$DetailSuccessCopyWithImpl;
@useResult
$Res call({
 Details detail
});


$DetailsCopyWith<$Res> get detail;

}
/// @nodoc
class _$DetailSuccessCopyWithImpl<$Res>
    implements $DetailSuccessCopyWith<$Res> {
  _$DetailSuccessCopyWithImpl(this._self, this._then);

  final DetailSuccess _self;
  final $Res Function(DetailSuccess) _then;

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,}) {
  return _then(DetailSuccess(
null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as Details,
  ));
}

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DetailsCopyWith<$Res> get detail {
  
  return $DetailsCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

/// @nodoc


class DetailFailed implements DetailViewState {
  const DetailFailed(this.message);
  

 final  String message;

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailFailedCopyWith<DetailFailed> get copyWith => _$DetailFailedCopyWithImpl<DetailFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DetailViewState.failed(message: $message)';
}


}

/// @nodoc
abstract mixin class $DetailFailedCopyWith<$Res> implements $DetailViewStateCopyWith<$Res> {
  factory $DetailFailedCopyWith(DetailFailed value, $Res Function(DetailFailed) _then) = _$DetailFailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DetailFailedCopyWithImpl<$Res>
    implements $DetailFailedCopyWith<$Res> {
  _$DetailFailedCopyWithImpl(this._self, this._then);

  final DetailFailed _self;
  final $Res Function(DetailFailed) _then;

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DetailFailed(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
