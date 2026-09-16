import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';

import '../state/add_event_mixin.dart';
import '../state/add_state_mixin.dart';

/// 게시판 목록을 이름으로 걸러내는 검색 입력창.
/// 테두리 대신 배경만 옅게 깔린 알약형이라 목록을 시각적으로 방해하지 않는다.
class const BoardSearchField({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<BoardSearchField> createState() => _BoardSearchFieldState();
}

class _BoardSearchFieldState()
    extends ConsumerState<BoardSearchField>
    with AddState, AddEvent {
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

  void _onChanged(String value) => updateSearchQuery(ref, value);

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MainItem? parent = drillParent(ref);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fill = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.04);
    final Color hintColor = theme.textTheme.bodySmall?.color ?? theme.hintColor;
    final String query = searchQuery(ref);
    // 단계를 오가면 검색어가 비워진다(범위가 달라지므로). 입력창에 남은
    // 글자도 같이 지워 화면과 실제 필터가 어긋나지 않게 한다.
    listenSearchQuery(ref, (next) {
      if (next != _controller.text) _controller.text = next;
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
      child: SizedBox(
        height: 42,
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: fill,
            hintText: parent == null ? '게시판 검색' : '${parent.text}에서 검색',
            hintStyle: TextStyle(fontSize: 14, color: hintColor),
            prefixIcon: Icon(Icons.search, size: 18, color: hintColor),
            prefixIconConstraints: const BoxConstraints(minWidth: 38),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    icon: Icon(Icons.cancel, size: 17, color: hintColor),
                    splashRadius: 18,
                    onPressed: _clear,
                  ),
            suffixIconConstraints: const BoxConstraints(minWidth: 38),
            contentPadding: const EdgeInsets.symmetric(vertical: 11),
            // 평소엔 테두리 없이 배경만, 포커스일 때만 강조색 실선.
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(color: theme.focusColor, width: 1.4),
            ),
          ),
        ),
      ),
    );
  }
}
