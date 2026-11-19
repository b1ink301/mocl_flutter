import 'package:flutter/widgets.dart';

/// 앱 어딘가에서 사용자가 스크롤하고 있는지(최근 스크롤 시각).
///
/// 웹뷰 생성 · 해제처럼 Android 메인 스레드(= Flutter UI 스레드)를 잠깐 막는 일을
/// 스크롤이 멈춘 뒤로 미룰 때 본다. [AppScrollActivityListener] 가 앱 맨 위에서
/// 모든 화면의 스크롤 알림을 받아 기록한다.
abstract final class AppScrollActivity() {
  static DateTime? _lastScrollAt;

  /// 이만큼 스크롤이 없으면 조용하다고 본다.
  static const Duration quietAfter = Duration(milliseconds: 800);

  static void markScrolled() => _lastScrollAt = DateTime.now();

  static bool get isQuiet {
    final DateTime? last = _lastScrollAt;
    return last == null || DateTime.now().difference(last) >= quietAfter;
  }
}

/// 아래 모든 스크롤뷰의 스크롤을 [AppScrollActivity] 에 기록한다(알림은 그대로 올려 보낸다).
class const AppScrollActivityListener({super.key, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollUpdateNotification n) {
          if (n.dragDetails != null || n.scrollDelta != 0) {
            AppScrollActivity.markScrolled();
          }
          return false;
        },
        child: child,
      );
}
