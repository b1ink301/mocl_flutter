import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_stateless_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/view_model_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/main_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class MainPage extends BaseStatelessView<MainViewModel> {
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
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appBarTitle =
            ref.watch(viewModelProvider.select((vm) => vm.appBarTitle()));
        final viewModel = ref.read(viewModelProvider.notifier);
        return Scaffold(
          drawer: DrawerWidget(
            onChangeSite: (siteType) => viewModel.changeSiteType(siteType),
          ),
          appBar: _buildAppBar(context, appBarTitle, viewModel.showSetListDlg),
          body: const MainView(),
        );
      },
    );
  }

  // @override
  @override
  AutoDisposeChangeNotifierProvider<MainViewModel> get viewModelProvider =>
      mainViewModelProvider;
}
