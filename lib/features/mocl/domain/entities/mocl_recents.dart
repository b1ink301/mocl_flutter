import 'package:freezed_annotation/freezed_annotation.dart';

part 'mocl_recents.freezed.dart';

@freezed
abstract class Recents with _$Recents {
  const factory Recents({
    @Default([]) List<Recent> articles,
    @Default([]) List<Recent> comments,
  }) = _Recents;
}

@freezed
abstract class Recent with _$Recent {
  const factory Recent({
    @Default('') String title,
    @Default('') String time,
    @Default({}) Map<String, dynamic> extraData,
  }) = _Recent;
}
