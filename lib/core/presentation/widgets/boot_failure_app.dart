import 'package:material_ui/material_ui.dart';

/// 부팅에 실패했거나 너무 오래 걸릴 때 스플래시 대신 띄우는 독립 앱.
///
/// 부팅이 실패한 상태라 provider · DB · 테마 설정 어느 것도 믿을 수 없으므로
/// 기본 위젯만으로 그린다.
///
/// 화면 루트에 [semanticsId] 를 달아 둔다. release 스모크 테스트
/// (`tool/release_smoke_test.sh`)가 UI 트리에서 이 id 를 찾아 "첫 프레임은
/// 그려졌지만 부팅은 실패한" 경우를 잡아낸다.
class const BootFailureApp({
  super.key,

  /// null 이면 시간 초과(부팅이 아직 진행 중)다.
  final Object? error,
  final VoidCallback? onRetry,
}) extends StatelessWidget {
  static const String semanticsId = 'boot_failure';

  @override
  Widget build(BuildContext context) {
    const Color seed = Color(0xFFEB6642);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed),
      darkTheme: ThemeData(colorSchemeSeed: seed, brightness: Brightness.dark),
      home: Semantics(
        identifier: semanticsId,
        container: true,
        child: _BootFailureView(error: error, onRetry: onRetry),
      ),
    );
  }
}

class const _BootFailureView({final Object? error, final VoidCallback? onRetry})
    extends StatefulWidget {
  @override
  State<_BootFailureView> createState() => _BootFailureViewState();
}

class _BootFailureViewState() extends State<_BootFailureView> {
  bool _retrying = false;

  bool get _timedOut => widget.error == null;

  /// 재시도가 또 실패하면 BootGuard 가 같은 자리에 새 화면을 `runApp` 한다.
  /// 위젯 타입이 같아 이 State 가 재사용되므로, 결과가 바뀌면 진행 표시를 푼다.
  /// (안 풀면 버튼 대신 스피너가 영원히 돈다)
  @override
  void didUpdateWidget(_BootFailureView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error != oldWidget.error ||
        widget.onRetry != oldWidget.onRetry) {
      _retrying = false;
    }
  }

  void _retry() {
    setState(() => _retrying = true);
    widget.onRetry?.call();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final VoidCallback? onRetry = widget.onRetry;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _timedOut ? Icons.hourglass_top : Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  _timedOut ? '시작이 늦어지고 있어요' : '앱을 시작하지 못했어요',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _timedOut
                      ? '준비가 끝나면 자동으로 열려요. 계속 이 화면이면 앱을 다시 실행해 주세요.'
                      : '다시 시도해도 같으면 앱을 업데이트하거나 다시 설치해 주세요.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (widget.error case final Object error) ...[
                  const SizedBox(height: 16),
                  // 문의할 때 알려줄 수 있도록 오류 종류만 짧게 보여준다.
                  SelectableText(
                    _summary(error),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                if (_timedOut || _retrying)
                  const CircularProgressIndicator()
                else if (onRetry != null)
                  FilledButton(onPressed: _retry, child: const Text('다시 시도')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _summary(Object error) {
    final String firstLine = error.toString().split('\n').first;
    return firstLine.length > 120
        ? '${firstLine.substring(0, 120)}…'
        : firstLine;
  }
}
