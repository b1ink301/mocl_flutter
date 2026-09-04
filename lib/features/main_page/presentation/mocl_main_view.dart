import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
// SiteType.title 확장을 쓴다(섞인 그룹에서 출처 표시).
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_actions_icon_theme.dart';
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

class const MainView({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState() extends ConsumerState<MainView> with FavoriteEvent {
  /// 빠른 이동 레일이 목록을 움직이려면 본문과 컨트롤러를 공유해야 한다.
  final ScrollController _controller = ScrollController();

  /// 그룹 헤더 슬라이버에 달아두는 키. 레일이 이 키로 각 그룹이 시작되는
  /// 스크롤 위치를 읽는다(화면 밖 그룹도 슬라이버는 배치되므로 잴 수 있다).
  final GroupHeaderKeys _headerKeys = <String, GlobalKey>{};

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
            slivers: <Widget>[
              const _MainAppBar(),
              _MainBody(headerKeys: _headerKeys),
            ],
          ),
        ),
        // 목록 위에 겹쳐 뜨지만 레일 알약 바깥은 터치가 그대로 목록으로 간다.
        Positioned.fill(
          child: QuickJumpRail(
            controller: _controller,
            headerKeys: _headerKeys,
          ),
        ),
      ],
    );
  }
}
