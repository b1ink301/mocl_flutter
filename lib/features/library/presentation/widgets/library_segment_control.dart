import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';
import 'package:mocl_flutter/features/library/domain/library_segment.dart';

/// 보관함의 `스크랩 | 히스토리` 전환.
///
/// 설정의 테마 선택과 같은 알약 트랙 모양으로 그리고(Material SegmentedButton 은 강조색이
/// 앱 테마와 어긋난다), 선택 표시는 트랙 위를 미끄러진다. 칸은 같은 폭으로 나눈다.
///
/// 폰에서는 큰 제목과 같은 좌우 여백으로 화면 폭을 채운다(폭을 고정하면 넓은 폰에서
/// 오른쪽만 비어 어긋나 보인다). 넓은 화면에서는 [_maxWidth] 까지만 늘리고 제목 쪽에 붙인다.
class const LibrarySegmentControl({
  super.key,
  required final LibrarySegment selected,
  required final ValueChanged<LibrarySegment> onChanged,
  final TextStyle? labelStyle,
}) extends StatelessWidget {
  static const Map<LibrarySegment, String> _labels = <LibrarySegment, String>{
    LibrarySegment.bookmarks: '스크랩',
    LibrarySegment.history: '히스토리',
  };

  static const double _height = 38;
  static const double _maxWidth = 480;

  /// 트랙과 선택 표시 사이 간격. 선택 표시의 둥글기를 이만큼 줄여 곡선을 나란히 맞춘다.
  static const double _inset = 3;
  static const Duration _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color focusColor = theme.colorScheme.primary;
    final List<LibrarySegment> segments = LibrarySegment.values;
    // 큰 글자 설정에서 라벨이 잘리지 않게 높이도 같이 키운다.
    final double height = MediaQuery.textScalerOf(context)
        .scale(_height)
        .clamp(_height, _height * 2);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        kLargeTitleStartInset,
        4,
        kLargeTitleStartInset,
        8,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double segmentWidth =
                  constraints.maxWidth / segments.length;
              return Container(
                height: height,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.07)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(height / 2),
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: _duration,
                      curve: Curves.easeOutCubic,
                      left: segmentWidth * segments.indexOf(selected),
                      top: 0,
                      bottom: 0,
                      width: segmentWidth,
                      child: Container(
                        margin: const EdgeInsets.all(_inset),
                        decoration: BoxDecoration(
                          color: focusColor.withValues(
                            alpha: isDark ? 0.30 : 0.16,
                          ),
                          borderRadius: BorderRadius.circular(
                            height / 2 - _inset,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (final LibrarySegment segment in segments)
                          _Segment(
                            label: _labels[segment]!,
                            semanticsId: 'library_${segment.name}',
                            isSelected: segment == selected,
                            width: segmentWidth,
                            radius: height / 2 - _inset,
                            labelStyle: labelStyle,
                            onTap: () => onChanged(segment),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class const _Segment({
  required final String label,
  required final String semanticsId,
  required final bool isSelected,
  required final double width,
  required final double radius,
  required final TextStyle? labelStyle,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color tint = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Semantics(
      identifier: semanticsId,
      button: true,
      selected: isSelected,
      child: Container(
        width: width,
        // 잉크도 선택 표시와 같은 자리 · 둥글기로(트랙 안쪽 [LibrarySegmentControl._inset]).
        padding: const EdgeInsets.all(LibrarySegmentControl._inset),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (labelStyle ?? const TextStyle()).copyWith(
                  color: tint,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
