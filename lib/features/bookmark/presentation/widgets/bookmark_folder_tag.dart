import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/category_tag.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';

/// 폴더 색. 말머리 태그 색을 그대로 쓴다(저장 값은 순번).
CategoryTone folderToneOf(int tone) =>
    CategoryTone.values[tone.clamp(0, CategoryTone.values.length - 1)];

extension BookmarkFolderColor on BookmarkFolder {
  Color colorOf(Brightness brightness) => folderToneOf(tone).color(brightness);
}

/// 스크랩 행에 붙는 폴더 이름 태그(말머리 태그와 같은 모양).
class const BookmarkFolderTag({
  super.key,
  required final BookmarkFolder folder,
  final double fontSize = 11,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color color = folder.colorOf(Theme.of(context).brightness);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(fontSize * 0.52),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: fontSize * 0.6,
          vertical: fontSize * 0.2,
        ),
        child: Text(
          folder.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

/// 폴더 색 고르기(동그라미 여섯 개).
class const BookmarkToneSelector({
  super.key,
  required final int selected,
  required final ValueChanged<int> onChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final Color ring = Theme.of(context).colorScheme.onSurface;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        for (final CategoryTone tone in CategoryTone.values)
          Semantics(
            button: true,
            selected: tone.index == selected,
            label: '색 ${tone.index + 1}',
            child: GestureDetector(
              onTap: () => onChanged(tone.index),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tone.color(brightness),
                  border: tone.index == selected
                      ? Border.all(color: ring, width: 2.5)
                      : null,
                ),
                child: tone.index == selected
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}
