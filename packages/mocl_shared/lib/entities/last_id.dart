import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_id.freezed.dart';

@freezed
abstract class LastId with _$LastId {
  const factory({
    dynamic extra,
    @Default(-1) int intId,
    @Default('') String stringId,
  }) = _LastId;

  factory empty() => const LastId();
}
