import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/detail_page/presentation/widgets/detail_scope.dart';

import '../../../config/mocl_text_styles.dart';
import '../../../core/application/app_provider.dart';
import '../../../core/util/utilities.dart';
import 'widgets/detail_appbar.dart';
import 'mocl_detail_view.dart';
import 'state/detail_event_mixin.dart';

class const DetailPage({super.key}) extends StatelessWidget {
  static Widget init(double width, ListItem item) => ProviderScope(
    overrides: DetailEvent.overridesProviderScope(width, item),
    child: const DetailPage(),
  );

  @override
  Widget build(BuildContext context) {
    const child = _DetailScaffold();

    return Platform.isMacOS || Platform.isAndroid
        ? Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              if (event.kind == PointerDeviceKind.mouse &&
                  event.buttons == kSecondaryMouseButton) {
                context.pop();
              }
            },
            child: child,
          )
        : child;
  }
}

/// macOS/web 은 기본 선택 동작을 쓰고, 그 외 플랫폼만 [SelectionArea] 로 감싼다.
Widget _selectable(Widget child) =>
    kIsWeb || Platform.isMacOS ? child : SelectionArea(child: child);

class const _DetailScaffold() extends ConsumerWidget with DetailEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;

    final String hexColor = theme.focusColor.stringHexColor;
    final focusColor = theme.focusColor;
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: DetailStyleScope(
        styles: styles,
        hexColor: hexColor,
        child: Scaffold(
          body: RefreshIndicator.adaptive(
            color: focusColor,
            onRefresh: () async => handleRefresh(ref),
            // SelectionArea 는 스크롤뷰 하나만 감싼다. 예전에는 본문/댓글의
            // HtmlWidget 마다 개별 SelectionArea 를 만들어 selectable 등록
            // 비용이 컸고, 본문을 sliver 로 렌더하면 box 위젯으로 감쌀 수도
            // 없다. 여기로 올리면 본문+댓글을 이어서 선택할 수도 있다.
            child: _selectable(
              const CustomScrollView(
                // 기본 250 은 본문 이미지 한 장 높이도 안 돼서, 조금만 스크롤해도
                // 방금 본 이미지가 언마운트되고 되돌아올 때 다시 디코딩된다.
                // 위아래로 화면 하나 정도는 살려둬 되감기 시 재디코딩을 줄인다.
                scrollCacheExtent: ScrollCacheExtent.pixels(600),
                slivers: [DetailAppBar(), DetailView()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
