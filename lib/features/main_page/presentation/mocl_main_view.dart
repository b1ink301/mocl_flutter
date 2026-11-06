import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
// 메인 맨 아래 광고는 광고가 너무 많아 잠시 꺼 뒀다(mocl_main_widgets.dart). 다시 켤 때 쓴다.
// ignore: unused_import
import 'package:mocl_flutter/features/ads/presentation/widgets/main_ad_tile.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_event_mixin.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/state/issue_radar_event_mixin.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/state/issue_radar_state_mixin.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/widgets/issue_home_card.dart';
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

class const MainView({super.key})
    extends ConsumerWidget
    with FavoriteEvent, IssueRadarState, IssueRadarEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusColor = Theme.of(context).colorScheme.primary;
    final bool radar = issueRadarAvailableState(ref);
    return RefreshIndicator.adaptive(
      color: focusColor,
      onRefresh: () async {
        refreshFavorites(ref);
        // 당겨서 새로고침하면 위의 "지금 이슈" 카드도 새로 받는다.
        if (radar) await refreshIssues(ref);
      },
      child: const CustomScrollView(
        slivers: <Widget>[
          MainAppBar(),
          SliverReadableWidth(sliver: _MainIssueCard()),
          // 넓은 화면에서는 게시판 목록을 읽기 좋은 폭으로 가운데 모은다.
          SliverReadableWidth(sliver: _MainBody()),
        ],
      ),
    );
  }
}
