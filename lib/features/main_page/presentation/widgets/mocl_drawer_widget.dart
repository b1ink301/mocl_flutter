import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/app_version_widget.dart';

import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

class DrawerWidget extends ConsumerWidget with MainEvent {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final focusColor = Theme.of(context).focusColor;

    // 설정은 콘텐츠 소스가 아니라 앱 네비게이션이므로 사이트 그리드에서 제외하고
    // 헤더 우측 톱니 아이콘으로 분리한다. (enum 멤버 자체는 배선 때문에 유지)
    final siteTypes = SiteType.values
        .where((s) => s != SiteType.settings)
        .toList(growable: false);

    return Drawer(
      backgroundColor: scaffoldBackgroundColor,
      child: Column(
        children: [
          _DrawerHeader(
            onSettingsTap: () {
              context.pop();
              context.push(Routes.settings);
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 56,
              ),
              itemCount: siteTypes.length,
              itemBuilder: (context, index) {
                final siteType = siteTypes[index];
                return _DrawerSiteItem(
                  siteType: siteType,
                  focusColor: focusColor,
                  // 왼쪽 열 셀에만 오른쪽 세로 라인을 그려 두 열 사이를 구분.
                  isLeftColumn: index.isEven,
                  onTap: () => _handleSiteTap(context, ref, siteType),
                );
              },
            ),
          ),
          const SafeArea(child: AppVersionWidget()),
        ],
      ),
    );
  }

  void _handleSiteTap(BuildContext context, WidgetRef ref, SiteType siteType) {
    context.pop();
    changeSiteType(ref, siteType);
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.onSettingsTap});

  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      color: primaryColor,
      height: 210,
      child: Stack(
        children: [
          Center(
            child: ClipOval(
              child: Image.asset('assets/icon.png', width: 76, height: 76),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: IconButton(
              tooltip: '설정',
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: onSettingsTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerSiteItem extends ConsumerWidget with MainState {
  const _DrawerSiteItem({
    required this.siteType,
    required this.onTap,
    required this.focusColor,
    required this.isLeftColumn,
  });

  final SiteType siteType;
  final Color focusColor;
  final bool isLeftColumn;
  final VoidCallback onTap;

  // 가로선 좌우 인셋, 라인 두께.
  static const double _hInset = 10;
  static const double _lineThickness = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = isSiteType(ref, siteType);
    final theme = Theme.of(context);
    final baseStyle = smallTextStyleState(ref);
    final dividerColor = theme.dividerColor;

    // Border 는 끝까지 그려져 인셋을 줄 수 없으므로 라인을 직접 배치한다.
    return Stack(
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: onTap,
          child: Center(
            child: PlainText(
              textAlign: .center,
              siteType.title,
              style: baseStyle.copyWith(
                color: isSelected ? focusColor : baseStyle.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // 하단 가로 라인 (좌우 패딩)
        Positioned(
          left: _hInset,
          right: _hInset,
          bottom: 0,
          height: _lineThickness,
          child: ColoredBox(color: dividerColor),
        ),
      ],
    );
  }
}
