import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';
import 'package:mocl_flutter/features/library/domain/library_segment.dart';

/// 보관함의 `스크랩 | 히스토리` 전환.
///
/// 회색 트랙 위를 흰 손잡이(얕은 그림자)가 미끄러지는 모양이다. 강조색을 쓰지 않는다 —
/// 아래 폴더 칩 · 탭바의 선택 표시가 강조색이라, 같은 색이면 어느 쪽이 위 단계인지 헷갈린다.
/// 칸마다 글 수를 옆에 작게 붙인다(검색 중이면 검색어에 맞는 수).
///
/// 폰에서는 큰 제목과 같은 좌우 여백으로 화면 폭을 채운다(폭을 고정하면 넓은 폰에서
/// 오른쪽만 비어 어긋나 보인다). 넓은 화면에서는 [_maxWidth] 까지만 늘리고 제목 쪽에 붙인다.
class const LibrarySegmentControl({
  super.key,
  required final LibrarySegment selected,
  required final ValueChanged<LibrarySegment> onChanged,
  final TextStyle? labelStyle,

  /// 칸마다 글 수(null 이면 숫자를 붙이지 않는다).
  final Map<LibrarySegment, int?> counts = const {},
}) extends StatelessWidget {
  static const Map<LibrarySegment, String> _labels = <LibrarySegment, String>{
    LibrarySegment.bookmarks: '스크랩',
    LibrarySegment.history: '히스토리',
  };

  static const double _height = 40;
  static const double _maxWidth = 480;
  static const double _radius = 20;

  /// 트랙과 손잡이 사이 간격. 손잡이의 둥글기를 이만큼 줄여 곡선을 나란히 맞춘다.
  static const double _inset = 3;
  static const Duration _duration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final List<LibrarySegment> segments = LibrarySegment.values;
    // 큰 글자 설정에서 라벨이 잘리지 않게 높이도 같이 키운다.
    final double height = MediaQuery.textScalerOf(context)
        .scale(_height)
        .clamp(_height, _height * 2);
    final Color track = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.055);
    final Color thumb = isDark
        ? Color.alphaBlend(
            Colors.white.withValues(alpha: 0.12),
            theme.colorScheme.surfaceContainer,
          )
        : theme.colorScheme.surfaceContainerLowest;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        kLargeTitleStartInset,
        6,
        kLargeTitleStartInset,
        12,
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
                  color: track,
                  borderRadius: BorderRadius.circular(_radius),
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
                          color: thumb,
                          borderRadius: BorderRadius.circular(_radius - _inset),
                          boxShadow: isDark
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.10),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    spreadRadius: 0.5,
                                  ),
                                ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (final LibrarySegment segment in segments)
                          _Segment(
                            label: _labels[segment]!,
                            count: counts[segment],
                            semanticsId: 'library_${segment.name}',
                            isSelected: segment == selected,
                            width: segmentWidth,
                            radius: _radius - _inset,
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
  required final int? count,
  required final String semanticsId,
  required final bool isSelected,
  required final double width,
  required final double radius,
  required final TextStyle? labelStyle,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextStyle base = labelStyle ?? const TextStyle(fontSize: 13);
    final Color tint = isSelected ? scheme.onSurface : scheme.onSurfaceVariant;

    return Semantics(
      identifier: semanticsId,
      button: true,
      selected: isSelected,
      child: Container(
        width: width,
        // 잉크도 손잡이와 같은 자리 · 둥글기로(트랙 안쪽 [LibrarySegmentControl._inset]).
        padding: const EdgeInsets.all(LibrarySegmentControl._inset),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: label,
                      style: TextStyle(
                        color: tint,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    if (count != null)
                      TextSpan(
                        text: '  $count',
                        style: TextStyle(
                          color: isSelected
                              ? scheme.onSurfaceVariant
                              : scheme.outline,
                          fontSize: (base.fontSize ?? 13) * 0.85,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: base,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
