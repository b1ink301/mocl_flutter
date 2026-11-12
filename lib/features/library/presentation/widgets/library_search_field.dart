import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../state/library_event_mixin.dart';
import '../state/library_state_mixin.dart';

/// 보관함 앱바 제목 자리의 검색 입력창(게시판 탭 `MainSearchField` 와 같은 모양).
///
/// 검색을 여는 동안만 살아 있다. 입력하는 대로 거른다.
class const LibrarySearchField({super.key, required final String hint})
    extends ConsumerStatefulWidget {
  @override
  ConsumerState<LibrarySearchField> createState() => _LibrarySearchFieldState();
}

class _LibrarySearchFieldState()
    extends ConsumerState<LibrarySearchField>
    with LibraryState, LibraryEvent {
  late final TextEditingController _controller = TextEditingController(
    text: readLibrarySearch(ref) ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color hintColor =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurfaceVariant;
    return Semantics(
      identifier: 'library_search_field',
      child: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyLarge,
        onChanged: (value) => updateLibrarySearch(ref, value),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 15, color: hintColor),
        ),
      ),
    );
  }
}
