import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';

/// 빈 화면 · 오류 화면의 공통 모양. 아이콘 + 제목 + 설명 + (주 / 보조) 버튼.
///
/// 오류는 [FailureView](`failure_view.dart`)가 이 위젯으로 그리고, 빈 목록
/// (담은 게시판 없음 · 스크랩 없음 · 검색 결과 없음 · 이슈 없음)도 이 위젯을 써서
/// 화면마다 같은 모양으로 보이게 한다.
/// sliver 가 필요한 곳에서는 [SliverMessageView] 로 감싼다.
class const MessageView({
  super.key,
  required final IconData icon,
  required final String title,
  required final String description,
  final String? primaryLabel,
  final VoidCallback? onPrimary,
  final String? secondaryLabel,
  final VoidCallback? onSecondary,
  final TextStyle? titleStyle,
  final TextStyle? descriptionStyle,

  /// 루트에 붙일 `Semantics(identifier:)`(기기 확인 스크립트용).
  final String? semanticsId,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final Color muted = foreground.withValues(alpha: 0.6);

    final TextStyle titleText = (titleStyle ?? const TextStyle(fontSize: 16))
        .copyWith(color: foreground, fontWeight: FontWeight.w600);
    final TextStyle descriptionText =
        (descriptionStyle ?? const TextStyle(fontSize: 14)).copyWith(
          color: muted,
          height: 1.4,
        );

    final VoidCallback? primary = onPrimary;
    final VoidCallback? secondary = onSecondary;
    final String? primaryText = primaryLabel;
    final String? secondaryText = secondaryLabel;
    final bool showPrimary = primary != null && primaryText != null;
    final bool showSecondary = secondary != null && secondaryText != null;

    return Semantics(
      identifier: semanticsId,
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            PlainIcon(icon, size: 44, color: muted),
            PlainText(title, style: titleText, textAlign: TextAlign.center),
            PlainText(
              description,
              style: descriptionText,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            if (showPrimary || showSecondary)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    if (showPrimary)
                      FilledButton.tonal(
                        onPressed: primary,
                        child: PlainText(primaryText, style: descriptionText),
                      ),
                    if (showSecondary)
                      TextButton(
                        onPressed: secondary,
                        child: PlainText(secondaryText, style: descriptionText),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 스크롤뷰의 남은 높이 가운데에 [child](보통 [MessageView] · `FailureView`)를 둔다.
///
/// 홈 탭은 본문이 떠 있는 탭바 뒤까지 확장되므로(`extendBody`), 아래 여백
/// (`MediaQuery.padding.bottom`, 탭바 높이 포함)만큼 올려 보이는 영역 가운데에 맞춘다.
class const SliverMessageView({super.key, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverFillRemaining(
    hasScrollBody: false,
    child: Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      child: Center(child: child),
    ),
  );
}
