import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/add_event_mixin.dart';
import '../state/add_state_mixin.dart';

/// 게시판 선택 목록을 이름/카테고리로 걸러내는 검색 입력창.
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
    final query = searchQuery(ref);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isDense: true,
          hintText: '게시판 검색',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: _clear,
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
