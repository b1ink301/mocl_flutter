import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/ads/presentation/widgets/main_ad_tile.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_event_mixin.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_event_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/main_appbar.dart';

import '../../../core/presentation/widgets/failure_view.dart';
import '../../../core/presentation/widgets/plain_divider_widget.dart';
import '../../../core/presentation/widgets/plain_icon.dart';
import '../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../core/presentation/widgets/plain_text.dart';
import '../../../core/presentation/widgets/site_avatar.dart';
import '../../database/domain/entities/favorite_data.dart';
import '../../database/domain/entities/favorite_group.dart';

part 'widgets/mocl_main_widgets.dart';

class const MainView({super.key}) extends ConsumerWidget with FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusColor = Theme.of(context).colorScheme.primary;
    return RefreshIndicator.adaptive(
      color: focusColor,
      onRefresh: () async => refreshFavorites(ref),
      child: const CustomScrollView(
        slivers: <Widget>[MainAppBar(), _MainBody()],
      ),
    );
  }
}
