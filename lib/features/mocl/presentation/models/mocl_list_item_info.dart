import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class MoclListItemInfo extends Equatable {
  final TextStyle titleStyle;
  final TextStyle smallTitleStyle;
  final TextStyle badgeStyle;
  final String id;
  final String reply;
  final String nickImage;
  final String title;
  final String info;
  final bool isRead;
  final int index;
  final double height;

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
    this.height = 0,
  });

  @override
  List<Object?> get props => [id, reply, info, isRead];
}

extension ListItemExtension on ListItem {
  MoclListItemInfo toListItemInfo(
      BuildContext context, int index, double height) {
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
      height: height,
    );
  }
}
