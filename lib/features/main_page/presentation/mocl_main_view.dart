import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/adaptive_popup_menu.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_actions_icon_theme.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/util/platform_util.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_event_mixin.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_event_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';

import '../../../core/presentation/widgets/plain_divider_widget.dart';
import '../../../core/presentation/widgets/plain_icon.dart';
import '../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../core/presentation/widgets/plain_text.dart';

part 'widgets/mocl_main_widgets.dart';

class const MainView({super.key}) extends ConsumerWidget with MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusColor = Theme.of(context).focusColor;
    return RefreshIndicator.adaptive(
      color: focusColor,
      onRefresh: () async => handleRefresh(ref),
      child: const CustomScrollView(
        slivers: <Widget>[_MainAppBar(), _MainBody()],
      ),
    );
  }
}
