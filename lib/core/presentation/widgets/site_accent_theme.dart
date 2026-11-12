import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/accent_palette.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/application/accent_mixin.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// "사이트 색" 모드에서 [child] 를 [site] 의 강조색으로 덮는다(목록 · 검색 · 상세 화면).
///
/// 전역 테마는 드로어에서 고른 사이트 색이라, 이슈 · 히스토리 · 링크로 연 다른 사이트 글도
/// 그 글의 사이트 색으로 보이게 화면마다 덮는다. 다른 모드면 아무것도 하지 않는다.
class const SiteAccentTheme({
  super.key,
  required final SiteType site,
  required final Widget child,
}) extends ConsumerWidget with AppAccentState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!siteAccentModeState(ref)) return child;
    final Brightness brightness = Theme.of(context).brightness;
    // 테마는 색마다 캐시돼 있어(MoclTheme.of) 다시 만들지 않는다.
    return Theme(
      data: MoclTheme.of(brightness, AccentPalette.site(site)),
      child: child,
    );
  }
}
