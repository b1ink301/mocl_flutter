import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_id.freezed.dart';

@freezed
class LastId with _$LastId {
  const factory LastId({
    dynamic extra,
    @Default(-1) int intId,
    @Default('') String stringId,
  }) = _LastId;

  factory LastId.empty() => const LastId();
}
