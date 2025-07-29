import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_item_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

@immutable
class MoclListItem extends StatelessWidget {
  const MoclListItem({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ListItemCubit, ListItem>(
    buildWhen: (previous, current) => previous.isRead != current.isRead,
    builder: (context, item) => InkWell(
      onTap: () => context.read<ListItemCubit>().onTap(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              item.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: MoclTextStyles.of(context).title(item.isRead),
            ),
            if (item.info.isNotEmpty)
              _BottomWidget(
                reply: item.reply,
                info: item.info,
                isRead: item.isRead,
              ),
          ],
        ),
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
