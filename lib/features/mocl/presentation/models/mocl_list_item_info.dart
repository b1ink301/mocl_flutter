import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class MoclListItemInfo extends Equatable {
  final String id;
  final String reply;
  final String nickImage;
  final String title;
  final String info;
  final bool isRead;
  final int index;
  final double height;

  const MoclListItemInfo({
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

    return MoclListItemInfo(
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
