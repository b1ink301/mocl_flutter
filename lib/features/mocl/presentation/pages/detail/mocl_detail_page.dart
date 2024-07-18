import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';

import '../../../domain/entities/mocl_list_item.dart';
import '../../../domain/entities/mocl_result.dart';
import '../../widgets/message_widget.dart';
import 'mocl_detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  DetailPage({super.key, required ListItem listItem}) {
    controller.setListItem(listItem);
  }

  Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MessageWidget(
            message: '다모앙',
            fontSize: 13,
          ),
          MessageWidget(
            message: controller.getAppbarTitle(),
          ),
        ],
      );

  SliverAppBar buildAppbar(BuildContext context) => SliverAppBar(
        title: buildTitle(),
        expandedHeight: 50.0,
        automaticallyImplyLeading: false,
        elevation: 8,
        floating: true,
        pinned: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          // physics: const BouncingScrollPhysics(),
          controller: controller.scrollController,
          slivers: <Widget>[
            buildAppbar(context),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 4, 10),
              child: _DetailView(),
            )),
          ],
        ),
      );
}

class _DetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView> {
  final DetailController detailController = Get.find();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Result>(
      stream: detailController.deailStream.asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // 로딩 중 표시
        }
        if (snapshot.hasData) {
          if (snapshot.data is ResultSuccess) {
            var result = snapshot.data as ResultSuccess<Details>;
            return SingleChildScrollView(
              child: Column(
                children: [
                  HtmlWidget(result.data.bodyHtml,
                      textStyle: const TextStyle(fontSize: 16)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: result.data.comments.length, // 아이템 개수
                    itemBuilder: (BuildContext context, int index) {
                      var comment = result.data.comments[index];
                      return ListTile(
                        title: Column(
                          children: [
                            Text(
                              comment.userInfo.nickName,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 13),
                            ),
                            HtmlWidget(comment.bodyHtml),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          }
        } else {
          return const MessageWidget(message: 'message');
        }
        return const MessageWidget(message: 'message');
      },
    );
  }
}
