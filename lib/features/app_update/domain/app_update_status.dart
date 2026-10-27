/// 스토어(Play · App Store)에 올라온 버전과 비교한 업데이트 진행 단계.
enum AppUpdatePhase() {
  /// 아직 확인하지 않았다.
  idle,
  checking,

  /// 설치된 버전이 스토어 최신이다.
  upToDate,

  /// 새 버전이 있다. Android 는 받기 시작 전, iOS 는 App Store 로 보낼 수 있다.
  available,

  /// Android 유연 업데이트를 내려받는 중.
  downloading,

  /// Android 유연 업데이트를 다 받았다. 재시작하면 설치된다.
  downloaded,

  /// 확인할 수 없다(스토어에서 설치하지 않은 빌드 · 스토어에 없음 · 네트워크).
  unavailable,
}

/// [storeVersion] 은 스토어의 새 버전. iOS 는 '1.5.3' 같은 버전 이름,
/// Android 는 Play 가 버전 이름을 주지 않아 버전 코드를 문자열로 담는다.
final class const AppUpdateStatus({
  final AppUpdatePhase phase = AppUpdatePhase.idle,
  final String? storeVersion,
}) {
  AppUpdateStatus copyWith({AppUpdatePhase? phase, String? storeVersion}) =>
      AppUpdateStatus(
        phase: phase ?? this.phase,
        storeVersion: storeVersion ?? this.storeVersion,
      );

  @override
  bool operator ==(Object other) =>
      other is AppUpdateStatus &&
      other.phase == phase &&
      other.storeVersion == storeVersion;

  @override
  int get hashCode => Object.hash(phase, storeVersion);
}
