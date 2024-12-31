import 'package:flutter/material.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

/// 게시글 목록의 각 항목을 표시하는 위젯
///
/// [item] 표시할 게시글 정보
/// [isRead] 읽음 상태
/// [textStyles] 텍스트 스타일
/// [onTap] 탭 이벤트 핸들러
class CachedListItem extends StatelessWidget {
  final ListItem item;
  final ValueNotifier<bool> isRead;
  final VoidCallback onTap;

  static const EdgeInsets _contentPadding =
      EdgeInsets.only(left: 16, right: 12);
  static const double _minVerticalPadding = 10;
  static const double _minTileHeight = 24;

  const CachedListItem({
    required this.item,
    required this.isRead,
    required this.onTap,
    super.key,
  });

  factory CachedListItem.empty() => CachedListItem(
        item: ListItem.empty(),
        isRead: ValueNotifier(false),
        onTap: () {},
      );

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: isRead,
        builder: (context, isReadValue, _) {
          try {
            return ListTile(
              minVerticalPadding: _minVerticalPadding,
              minTileHeight: _minTileHeight,
              contentPadding: _contentPadding,
              onTap: onTap,
              title: TitleView(
                title: item.title,
                isRead: isReadValue,
              ),
              subtitle: BottomView(
                item: item,
                isRead: isReadValue,
              ),
            );
          } catch (e) {
            debugPrint('Error building CachedListItem: $e');
            return Text(
              e.toString(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: MoclTextStyles.of(context).smallTitle(false),
            );
          }
        },
      );
}

class TitleView extends StatelessWidget {
  final String title;
  final bool isRead;

  const TitleView({
    super.key,
    required this.title,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: MoclTextStyles.of(context).title(isRead),
    );
  }
}

class BottomView extends StatelessWidget {
  final ListItem item;
  final bool isRead;

  const BottomView({
    super.key,
    required this.item,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    if (item.userInfo.id.isEmpty) {
      return const SizedBox.shrink();
    }

    final reply = item.reply;
    final nickImage = item.userInfo.nickImage;
    final hasReply = reply.isNotEmpty && reply != '0';

    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (nickImage.isNotEmpty && nickImage.startsWith('http'))
                      NickImageWidget(url: nickImage),
                    Flexible(
                      child: InfoText(
                        info: item.info,
                        isRead: isRead,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasReply)
                RoundTextWidget(
                  text: reply,
                  textStyle: MoclTextStyles.of(context).badge(isRead),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  final String info;
  final bool isRead;

  const InfoText({
    super.key,
    required this.info,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      info,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: MoclTextStyles.of(context).smallTitle(isRead),
    );
  }
}

class ReplyBadge extends StatelessWidget {
  final String reply;
  final bool isRead;

  const ReplyBadge({
    super.key,
    required this.reply,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return RoundTextWidget(
      text: reply,
      textStyle: MoclTextStyles.of(context).badge(isRead),
    );
  }
}
