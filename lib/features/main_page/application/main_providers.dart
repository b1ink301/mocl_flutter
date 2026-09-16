import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/settings_page/application/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_providers.g.dart';

/// 앱바 제목. 홈은 '지금 보고 있는 사이트'의 담은 게시판 목록이다.
@riverpod
String mainTitle(Ref ref) =>
    ref.watch(currentSiteTypeProvider.select((SiteType state) => state.title));

/// 드로어 사이트 칩이 자기 차례인지만 골라 보게 한다(사이트가 바뀌어도
/// 관련 있는 칩 두 개만 다시 그려진다).
@riverpod
bool isCurrentSiteType(Ref ref, SiteType siteType) => ref.watch(
  currentSiteTypeProvider.select((SiteType state) => state == siteType),
);

/// 드로어를 열고 닫기 위한 Scaffold 키.
@Riverpod(keepAlive: true)
GlobalKey<ScaffoldState> mainScaffoldState(Ref ref) =>
    GlobalKey<ScaffoldState>();

/// 드로어가 열려 있는지. 뒤로가기로 드로어부터 닫기 위해 들고 있는다.
@riverpod
class MainSidebarNotifier() extends _$MainSidebarNotifier {
  @override
  bool build() => false;

  void open() => state = true;

  void close() => state = false;
}

/// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).
@riverpod
class MainTabIndex() extends _$MainTabIndex {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 삭제 버튼이
/// 노출된다(평소엔 탭으로 게시판 이동).
@riverpod
class MainEditMode() extends _$MainEditMode {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void off() => state = false;
}

/// 내 게시판 검색창이 열려 있는지.
@riverpod
class MainSearchOpen() extends _$MainSearchOpen {
  @override
  bool build() => false;

  void open() => state = true;

  void close() => state = false;
}

/// 내 게시판 검색어. 담은 게시판이 수십 개가 되면 스크롤·빠른 이동보다
/// 두 글자 입력이 빠르다.
@riverpod
class MainSearchQuery() extends _$MainSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// 접어둔 카페 소구획 키 집합. 그룹 접힘과 같이 앱을 다시 켜도 유지된다.
@Riverpod(keepAlive: true)
class CollapsedSubSections() extends _$CollapsedSubSections {
  @override
  Set<String> build() =>
      ref.watch(settingsRepositoryProvider).getCollapsedSubSections().toSet();

  void toggle(String key) {
    final Set<String> next = Set<String>.of(state);
    if (!next.remove(key)) next.add(key);
    // 화면을 먼저 바꾸고 저장해 즉각 반응하게 한다(그룹 접힘과 동일).
    state = next;
    ref.read(settingsRepositoryProvider).setCollapsedSubSections(next.toList());
  }
}
