import 'dart:async';

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

  /// 글자마다 목록을 다시 거르면 게시판이 많은 사이트에서 입력이 끊긴다.
  /// 타이핑이 잠깐 멈췄을 때만 검색어를 반영한다.
  static const Duration _debounce = Duration(milliseconds: 200);
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: readSearchQuery(ref));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => updateSearchQuery(ref, value));
  }

  void _clear() {
    _debounceTimer?.cancel();
    _controller.clear();
    updateSearchQuery(ref, '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MainItem? parent = drillParent(ref);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fill = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.04);
    final Color hintColor =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurfaceVariant;
    // 단계를 오가면 검색어가 비워진다(범위가 달라지므로). 입력창에 남은
    // 글자도 같이 지워 화면과 실제 필터가 어긋나지 않게 한다.
    listenSearchQuery(ref, (next) {
      // 대기 중인 검색어가 바뀐 범위에 뒤늦게 들어가지 않게 함께 취소한다.
      if (next != _controller.text) {
        _debounceTimer?.cancel();
        _controller.text = next;
      }
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
      child: SizedBox(
        height: 42,
        // 지우기 버튼은 검색어 반영(디바운스)을 기다리지 않고 입력 즉시 보인다.
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => TextField(
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
              suffixIcon: _controller.text.isEmpty
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
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
