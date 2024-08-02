import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/views/mocl_show_add_dialog.dart';

import '../../../widgets/loading_widget.dart';
import '../../../widgets/message_widget.dart';
import '../controllers/mocl_main_controller.dart';
import 'mocl_drawer_widget.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  Widget _buildTitle() => Obx(() => MessageWidget(
        message: controller.siteName(),
      ));

  AppBar _buildAppbar(BuildContext context) => AppBar(
        title: _buildTitle(),
        titleSpacing: 0,
        toolbarHeight: 60,
        // elevation: 8,
        // scrolledUnderElevation: 8,
        actions: [
          IconButton(
            onPressed: () => _showAddDialog(context),
            icon: const Icon(Icons.add),
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: DrawerWidget(onChangeSite: controller.changeSite),
        appBar: _buildAppbar(context),
        body: const _MainBody(),
      );

  void _showAddDialog(
    BuildContext context,
  ) =>
      showDialog(
        context: context,
        builder: (context) => ShowAddDialog(),
      );
}

class _MainBody extends StatefulWidget {
  const _MainBody();

  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> {
  final MainController _controller = Get.find();

  @override
  Widget build(BuildContext context) => buildBodyContent(context);

  // Widget _buildResultSuccess(
  //   BuildContext context,
  //   ResultSuccess<List<MainItem>> result,
  // ) {
  //   if (result.data.isEmpty) {
  //     return Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Text(
  //         '항목이 없습니다\n오른쪽 상단의 +버튼을 눌려서\n항목을 추가해주세요',
  //         style: TextStyle(
  //           fontSize: 16,
  //           color: Theme.of(context).indicatorColor,
  //         ),
  //       ),
  //     );
  //   } else {
  //     return ListView.separated(
  //       itemCount: result.data.length,
  //       itemBuilder: (context, index) {
  //         final item = result.data[index];
  //         return Column(
  //           key: Key(item.board),
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             ListTile(
  //               minTileHeight: 64,
  //               title: Text(
  //                 item.text,
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //               onTap: () {
  //                 debugPrint('onTap item=$item');
  //                 _controller.gotoListPage(item);
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //       separatorBuilder: (BuildContext context, int index) {
  //         return const Divider(
  //           height: 1,
  //           thickness: 1,
  //           indent: 12,
  //           endIndent: 8,
  //         );
  //       },
  //     );
  //   }
  // }

  Widget _buildResultSuccess(
    BuildContext context,
    List<MainItem> data,
  ) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Column(
          key: Key(item.board),
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              minTileHeight: 64,
              title: Text(
                item.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                debugPrint('onTap item=$item');
                _controller.gotoListPage(item);
              },
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

// Widget buildBodyContent(BuildContext context) => Obx(() {
//       var data = _controller.data.value;
//       debugPrint("runtimeType=${data.runtimeType}");
//       if (data is ResultLoading) {
//         return const LoadingWidget();
//       } else if (data is ResultInitial) {
//         return const LoadingWidget();
//       } else if (data is ResultSuccess) {
//         var result = data as ResultSuccess<List<MainItem>>;
//         return _buildResultSuccess(context, result);
//       } else if (data is ResultFailure) {
//         return const MessageWidget(message: 'MainDataError');
//       } else {
//         return const MessageWidget(message: 'MainDataError');
//       }
//     });
}
