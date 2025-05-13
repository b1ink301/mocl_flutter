import 'package:flutter/material.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

@immutable
class MoclListItem extends StatelessWidget {
  const MoclListItem({super.key, required this.model, required this.onTap});

  final ReadableListItem model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: ValueListenableBuilder(
      valueListenable: model.isRead,
      builder:
          (_, isRead, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                model.item.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: MoclTextStyles.of(context).title(isRead),
              ),
              const SizedBox(height: 10),
              _BottomWidget(
                reply: model.item.reply,
                info: model.item.info,
                isRead: isRead,
              ),
              const SizedBox(height: 8),
            ],
          ),
    ),
  );
}

class _BottomWidget extends StatelessWidget {
  const _BottomWidget({
    required this.info,
    required this.reply,
    required this.isRead,
  });

  final String info;
  final String reply;
  final bool isRead;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 20,
    child: Row(
      children: [
        Expanded(
          child: Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MoclTextStyles.of(context).smallTitle(isRead),
          ),
        ),
        if (reply.isNotEmpty && reply != '0')
          RoundTextWidget(
            text: reply,
            textStyle: MoclTextStyles.of(context).badge(isRead),
          ),
      ],
    ),
  );
}
