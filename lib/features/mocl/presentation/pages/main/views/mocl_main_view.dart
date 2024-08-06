import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/mocl_main_controller.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainView> {
  final MainController _controller = Get.find();

  @override
  Widget build(BuildContext context) => buildBodyContent(context);

  Widget _buildResultSuccess(
      BuildContext context,
      List<MainItem> data,
      ) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Column(
          key: Key(item.board),
          // mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              minTileHeight: 64,
              title: Text(
                item.text,
                style: textStyle,
              ),
              onTap: () => _controller.gotoListPage(item),
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 1,
          thickness: 1,
          indent: 12,
          endIndent: 8,
        );
      },
    );
  }

  Widget buildBodyContent(BuildContext context) => _controller.obx(
        (data) {
      if (data == null) return const SizedBox.shrink();
      return _buildResultSuccess(context, data);
    },
    onLoading: const LoadingWidget(),
    onEmpty: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        '항목이 없습니다\n오른쪽 상단의 +버튼을 눌려서\n항목을 추가해주세요',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).indicatorColor,
        ),
      ),
    ),
    onError: (error) => Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        '에러가 발생했습니다',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).indicatorColor,
        ),
      ),
    ),
  );
}