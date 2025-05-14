import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<DetailViewBloc, DetailViewState>(
    buildWhen:
        (DetailViewState previous, DetailViewState current) =>
            current is DetailSuccess,
    builder: (BuildContext context, DetailViewState state) {
      switch (state) {
        case DetailSuccess():
          final bodySmall = Theme.of(context).textTheme.bodySmall!;

          final List likeView =
              state.detail.likeCount.isNotEmpty
                  ? [
                    const SizedBox(width: 10),
                    const Spacer(),
                    Icon(
                      Icons.favorite_outline,
                      color: bodySmall.color,
                      size: 17,
                    ),
                    const SizedBox(width: 4),
                    Text(state.detail.likeCount, style: bodySmall),
                    const SizedBox(width: 10),
                  ]
                  : [];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(state.detail.info, style: bodySmall),
                    ...likeView,
                  ],
                ),
              ),
              const DividerWidget(),
            ],
          );
        default:
          return const SizedBox(height: 46);
      }
    },
  );
}
