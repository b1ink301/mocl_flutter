import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../config/large_title_metrics.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/main_state_mixin.dart';

/// "지금 이슈" 카드 아래로 내려온 큰 사이트 제목(메인 고정 머리의 아랫줄).
///
/// 높이 · 여백 · 글자는 기존 앱바 펼침 영역([LargeTitleFlexibleSpace])과 같다.
/// 그래서 카드가 없을 때(받기 실패 · 이슈 없음 · 접히는 중) 툴바 + 이 줄이
/// 기존 큰 제목 앱바와 같은 자리에 같은 모양으로 놓인다 — 카드를 닫아 기존
/// 배치로 돌아갈 때 제목이 움직이지 않는다.
class const MainSiteTitle({super.key}) extends ConsumerWidget with MainState {
  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
    height: kLargeTitleExpandedHeightSingleLine - kToolbarHeight,
    child: Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Padding(
        padding: kLargeTitlePadding,
        child: Semantics(
          header: true,
          child: PlainText(
            titleState(ref),
            style: largeTitleStyle(titleTextStyleState(ref)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ),
  );
}
