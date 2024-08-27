import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/view_model_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/views/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/views/mocl_main_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  AppBar _buildAppBar(
    BuildContext context,
    String title,
    void Function(BuildContext context) handleAddButton,
  ) =>
      AppBar(
        title: _buildTitle(context, title),
        titleSpacing: 0,
        centerTitle: false,
        toolbarHeight: 64,
        actions: [
          IconButton(
            onPressed: () => handleAddButton(context),
            icon: const Icon(Icons.add),
          )
        ],
      );

  Widget _buildTitle(BuildContext context, String title) => MessageWidget(
        message: title,
        textStyle: Theme.of(context).textTheme.labelMedium,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarTitle =
        ref.watch(mainViewModelProvider.select((vm) => vm.appBarTitle()));
    final viewModel = ref.read(mainViewModelProvider.notifier);

    return Scaffold(
      drawer: DrawerWidget(
        onChangeSite: (siteType) => viewModel.changeSiteType(siteType),
      ),
      appBar: _buildAppBar(context, appBarTitle, viewModel.showSetListDlg),
      body: const MainView(),
    );
  }
}
