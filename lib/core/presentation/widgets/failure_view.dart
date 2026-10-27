import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';

/// 오류를 사용자에게 보여줄 형태(아이콘 · 제목 · 설명 · 재시도 가능 여부)로 정리한 값.
class const FailureInfo({
  required final IconData icon,
  required final String title,
  required final String description,
  required final bool retryable,
}) {
  /// 예외/실패 객체를 화면 문구로 변환한다. 개발자용 원시 메시지
  /// (DioException 본문, 스택트레이스 등)는 절대 그대로 노출하지 않는다.
  static FailureInfo of(Object? error) => switch (error) {
    NotLoginFailure(:final message) => FailureInfo(
      icon: Icons.lock_outline,
      title: '로그인이 필요해요',
      description: _humanize(message, '로그인한 뒤 다시 시도해 주세요.'),
      retryable: true,
    ),
    PermissionFailure(:final message) => FailureInfo(
      icon: Icons.do_not_disturb_on_outlined,
      title: '읽을 수 있는 권한이 없어요',
      description: _humanize(message, '게시판 등급이 올라가면 읽을 수 있어요.'),
      retryable: false,
    ),
    NetworkFailure(:final message) => FailureInfo(
      icon: Icons.wifi_off_outlined,
      title: '연결에 실패했어요',
      description: _humanize(message, '네트워크 상태를 확인한 뒤 다시 시도해 주세요.'),
      retryable: true,
    ),
    ServerFailure(:final message) => FailureInfo(
      icon: Icons.cloud_off_outlined,
      title: '사이트에 문제가 있어요',
      description: _humanize(message, '잠시 후 다시 시도해 주세요.'),
      retryable: true,
    ),
    GetDetailFailure(:final message) => FailureInfo(
      icon: Icons.article_outlined,
      title: '글을 불러오지 못했어요',
      description: _humanize(message, '잠시 후 다시 시도해 주세요.'),
      retryable: true,
    ),
    GetListFailure(:final message) => FailureInfo(
      icon: Icons.list_alt_outlined,
      title: '목록을 불러오지 못했어요',
      description: _humanize(message, '잠시 후 다시 시도해 주세요.'),
      retryable: true,
    ),
    GetMainFailure(:final message) => FailureInfo(
      icon: Icons.dashboard_outlined,
      title: '게시판을 불러오지 못했어요',
      description: _humanize(message, '잠시 후 다시 시도해 주세요.'),
      retryable: true,
    ),
    Failure(:final message) => FailureInfo(
      icon: Icons.error_outline,
      title: '문제가 발생했어요',
      description: _humanize(message, '잠시 후 다시 시도해 주세요.'),
      retryable: true,
    ),
    _ => const FailureInfo(
      icon: Icons.error_outline,
      title: '문제가 발생했어요',
      description: '잠시 후 다시 시도해 주세요.',
      retryable: true,
    ),
  };

  /// 서버가 준 사유가 사람이 읽을 수 있는 짧은 문장일 때만 쓰고,
  /// 스택/예외 문구처럼 보이면 [fallback] 으로 대체한다.
  static String _humanize(String message, String fallback) {
    final String text = message.trim();
    if (text.isEmpty || text.length > 80 || text.contains('\n')) {
      return fallback;
    }
    const List<String> technical = [
      'Exception',
      'Error:',
      'statusCode',
      'http',
      'HTTP ',
      'null',
      '#0',
    ];
    if (technical.any(text.contains)) return fallback;
    return text;
  }
}

/// 오류 화면. 아이콘 + 제목 + 설명 + (재시도 / 보조) 버튼.
///
/// sliver 가 필요한 곳에서는 호출부가 [SliverFillRemaining] 으로 감싼다.
class const FailureView({
  super.key,
  required final Object? error,
  final VoidCallback? onRetry,
  final String? secondaryLabel,
  final VoidCallback? onSecondary,
  final TextStyle? titleStyle,
  final TextStyle? descriptionStyle,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FailureInfo info = FailureInfo.of(error);
    final ThemeData theme = Theme.of(context);
    final Color foreground =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final Color muted = foreground.withValues(alpha: 0.6);

    final TextStyle title = (titleStyle ?? const TextStyle(fontSize: 16))
        .copyWith(color: foreground, fontWeight: FontWeight.w600);
    final TextStyle description =
        (descriptionStyle ?? const TextStyle(fontSize: 14)).copyWith(
          color: muted,
          height: 1.4,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          PlainIcon(info.icon, size: 44, color: muted),
          PlainText(info.title, style: title, textAlign: TextAlign.center),
          PlainText(
            info.description,
            style: description,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          ..._buildActions(info, description),
        ],
      ),
    );
  }

  /// 권한 부족처럼 다시 시도해도 결과가 같은 오류에는 재시도 버튼을 달지 않는다.
  List<Widget> _buildActions(FailureInfo info, TextStyle style) {
    final VoidCallback? retry = onRetry;
    final VoidCallback? secondary = onSecondary;
    final String? label = secondaryLabel;
    final bool showRetry = info.retryable && retry != null;
    final bool showSecondary = secondary != null && label != null;
    if (!showRetry && !showSecondary) return const [];

    return [
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            if (showRetry)
              ElevatedButton(
                onPressed: retry,
                child: PlainText('다시 시도', style: style),
              ),
            if (showSecondary)
              TextButton(
                onPressed: secondary,
                child: PlainText(label, style: style),
              ),
          ],
        ),
      ),
    ];
  }
}
