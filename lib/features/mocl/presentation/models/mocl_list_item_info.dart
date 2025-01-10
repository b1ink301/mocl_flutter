import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class MoclListItemInfo extends Equatable {
  final TextStyle titleStyle; // = textStyles.title(item.isRead);
  final TextStyle smallTitleStyle; // = textStyles.smallTitle(item.isRead);
  final TextStyle badgeStyle; // = textStyles.badge(item.isRead);
  final String id; // = item.userInfo.id;
  final String reply; // = item.reply;
  final String nickImage; // = item.userInfo.nickImage;
  final String title; // = item.info;
  final String info; // = item.info;
  final bool isRead;
  final int index;

  const MoclListItemInfo({
    required this.titleStyle,
    required this.smallTitleStyle,
    required this.badgeStyle,
    required this.id,
    required this.reply,
    required this.nickImage,
    required this.title,
    required this.info,
    required this.isRead,
    required this.index,
  });

  @override
  List<Object?> get props => [id, reply, info, isRead];
}

extension ListItemExtension on ListItem {
  MoclListItemInfo toListItemInfo(BuildContext context, int index) {
    final MoclTextStyles textStyles = MoclTextStyles.of(context);
    final TextStyle titleStyle = textStyles.title(isRead);
    final TextStyle smallTitleStyle = textStyles.smallTitle(isRead);
    final TextStyle badgeStyle = textStyles.badge(isRead);

    return MoclListItemInfo(
      titleStyle: titleStyle,
      smallTitleStyle: smallTitleStyle,
      badgeStyle: badgeStyle,
      id: userInfo.id,
      reply: reply,
      title: title,
      nickImage: userInfo.nickImage,
      info: info,
      isRead: isRead,
      index: index,
    );
  }
}
