import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_providers.g.dart';

@riverpod
bool isCurrentSiteType(Ref ref, SiteType siteType) =>
    ref.watch(currentSiteTypeProvider.select((state) => state == siteType));

@Riverpod(keepAlive: true)
GlobalKey<ScaffoldState> mainScaffoldState(Ref ref) =>
    GlobalKey<ScaffoldState>();

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
/// 버튼이 노출된다(평소엔 탭으로 게시판 이동).
@riverpod
class MainEditMode() extends _$MainEditMode {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void off() => state = false;
}

@riverpod
class MainSidebarNotifier() extends _$MainSidebarNotifier {
  @override
  bool build() => false;

  void open() => state = true;

  void close() => state = false;

  void toggle() => state = !state;
}
