import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

/// 앱바 제목 자리에 들어가는 담은 게시판 검색 입력창.
///
/// 검색을 여는 동안만 살아 있고, 닫으면 통째로 사라진다(컨트롤러도 같이
/// 버려지므로 다음에 열 때 저장된 검색어로 다시 채운다).
class const MainSearchField({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<MainSearchField> createState() => _MainSearchFieldState();
}

class _MainSearchFieldState()
    extends ConsumerState<MainSearchField>
    with MainState, MainEvent {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: readSearchQuery(ref));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color hintColor =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurfaceVariant;

    return TextField(
      controller: _controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      style: theme.textTheme.bodyLarge,
      onChanged: (value) => updateSearchQuery(ref, value),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: '담은 게시판 검색',
        hintStyle: TextStyle(fontSize: 15, color: hintColor),
      ),
    );
  }
}
