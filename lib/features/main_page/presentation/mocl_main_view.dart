import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_actions_icon_theme.dart';
import 'package:mocl_flutter/core/presentation/widgets/failure_view.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_avatar.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_event_mixin.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_event_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_quick_jump_rail.dart';

import '../../../core/presentation/widgets/plain_divider_widget.dart';
import '../../../core/presentation/widgets/plain_icon.dart';
import '../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../core/presentation/widgets/plain_text.dart';

part 'widgets/mocl_main_widgets.dart';

/// 홈 본문. 지금 고른 사이트에 담아둔 게시판 목록 + 오른쪽 사이트 전환 레일.
class const MainView({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState() extends ConsumerState<MainView> with FavoriteEvent {
  /// 레일이 스크롤에 맞춰 옅어졌다 또렷해지려면 본문과 컨트롤러를 공유해야 한다.
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    return Stack(
      children: <Widget>[
        RefreshIndicator.adaptive(
          color: focusColor,
          onRefresh: () async => refreshFavorites(ref),
          child: CustomScrollView(
            controller: _controller,
            slivers: const <Widget>[_MainAppBar(), _MainBody()],
          ),
        ),
        // 목록 위에 겹쳐 뜨지만 레일 알약 바깥은 터치가 그대로 목록으로 간다.
        Positioned.fill(child: SiteJumpRail(controller: _controller)),
      ],
    );
  }
}
