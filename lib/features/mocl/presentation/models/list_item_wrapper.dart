import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/mocl_list_item_info.dart';

part 'list_item_wrapper.freezed.dart';

@freezed
class ListItemWrapper with _$ListItemWrapper {
  factory ListItemWrapper({
    required ListItem item,
    required double height,
  }) = _ListItemWrapper;
}

extension ListItemWrapperExtension on ListItemWrapper {
  MoclListItemInfo toListItemInfo(BuildContext context, int index) {
    final MoclTextStyles textStyles = MoclTextStyles.of(context);

    return MoclListItemInfo(
      titleStyle: textStyles.title(item.isRead),
      smallTitleStyle: textStyles.smallTitle(item.isRead),
      badgeStyle: textStyles.badge(item.isRead),
      id: item.userInfo.id,
      reply: item.reply,
      title: item.title,
      nickImage: item.userInfo.nickImage,
      info: item.info,
      isRead: item.isRead,
      index: index,
    );
  }
}
