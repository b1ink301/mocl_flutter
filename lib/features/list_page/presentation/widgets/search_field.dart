import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';

/// 검색 화면 앱바의 둥근 검색 칸. 키보드 "검색" 으로 [onSubmitted],
/// 지우기 버튼으로 [onCleared] 를 부른다(지우면 다시 입력할 수 있게 포커스를 준다).
class const SearchField({
  super.key,
  required final TextEditingController controller,
  required final FocusNode focusNode,
  required final String hintText,
  required final ValueChanged<String> onSubmitted,
  required final VoidCallback onCleared,
  required final TextStyle textStyle,
}) extends StatelessWidget {
  static const String semanticsId = 'search_field';

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color muted = (textStyle.color ?? colors.onSurface).withValues(
      alpha: 0.55,
    );

    return Semantics(
      identifier: semanticsId,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        style: textStyle,
        cursorColor: colors.primary,
        maxLines: 1,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: colors.onSurface.withValues(alpha: 0.07),
          hintText: hintText,
          hintStyle: textStyle.copyWith(color: muted),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: PlainIcon(Icons.search_rounded, size: 20, color: muted),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : PlainIconButton(
                    semanticLabel: '검색어 지우기',
                    semanticsId: 'search_clear',
                    onPressed: () {
                      controller.clear();
                      focusNode.requestFocus();
                      onCleared();
                    },
                    icon: PlainIcon(
                      Icons.cancel_rounded,
                      size: 18,
                      color: muted,
                    ),
                  ),
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 36),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
