import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_providers.g.dart';

/// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).
@riverpod
class MainTabIndex() extends _$MainTabIndex {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
/// 버튼이 노출된다(평소엔 탭으로 게시판 이동).
@riverpod
class MainEditMode() extends _$MainEditMode {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void off() => state = false;
}
