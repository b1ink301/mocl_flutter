import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_show_add_dialog.dart';

import '../../widgets/divider_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/message_widget.dart';
import 'mocl_main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  MessageWidget buildTitle() => MessageWidget(
        message: controller.siteName(),
      );

  AppBar buildAppbar(BuildContext context) => AppBar(
        title: buildTitle(),
        // elevation: 8,
        // scrolledUnderElevation: 8,
        actions: [
          IconButton(
            onPressed: () => showAddDialog(context),
            icon: const Icon(Icons.add),
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppbar(context),
        body: const _MainBody(),
      );

  void showAddDialog(
    BuildContext context,
  ) =>
      showDialog(
        context: context,
        builder: (context) => ShowAddDialog(),
      );
}

class _MainBody extends StatefulWidget {
  const _MainBody({super.key});

  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> {
  final MainController _controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('dispose');
    _controller.closeSteam();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildBodyContent(context);

  Widget buildResultSuccess(ResultSuccess<List<MainItem>> result) {
    if (result.data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: MessageWidget(message: '항목이 비워 있습니다.'),
      );
    } else {
      return ListView.separated(
        itemCount: result.data.length,
        itemBuilder: (context, index) {
          final item = result.data[index];
          return Column(
            key: Key(item.board),
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                minTileHeight: 64,
                title: Text(item.text),
                onTap: () {
                  debugPrint('onTap item=$item');
                  _controller.gotoListPage(item);
                },
              ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1,
            thickness: 1,
            indent: 12,
            endIndent: 8,
          );
        },
      );
    }
  }

  Widget buildBodyContent(
    BuildContext context,
  ) =>
      StreamBuilder<Result>(
          stream: _controller.mainListStream.asBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              debugPrint("runtimeType=${snapshot.data.runtimeType}");
              if (snapshot.data is ResultLoading) {
                return const LoadingWidget();
              } else if (snapshot.data is ResultInitial) {
                return const LoadingWidget();
              } else if (snapshot.data is ResultSuccess) {
                var result =
                    snapshot.requireData as ResultSuccess<List<MainItem>>;
                return buildResultSuccess(result);
              } else if (snapshot.data is ResultFailure) {
                return const MessageWidget(message: 'MainDataError');
              } else {
                return const MessageWidget(message: 'MainDataError');
              }
            } else {
              return const Padding(
                padding: EdgeInsets.all(10.0),
                child: MessageWidget(message: '항목이 없습니다.'),
              );
            }
          });
}
