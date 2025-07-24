import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';

part 'checkable_main_item.freezed.dart';

@freezed
abstract class CheckableMainItem with _$CheckableMainItem {
  factory CheckableMainItem({
    required MainItem mainItem,
    required bool isChecked,
  }) = _CheckableMainItem;
}
