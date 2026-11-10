import 'dart:math' as math;
import 'dart:ui' show FlutterView;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

/// 화면 방향 정책.
///
/// 폰(짧은 변 < 600dp)은 세로로 고정하고, 태블릿 · iPad · 펼친 폴드는 모든
/// 방향을 허용한다. 폴드는 접고 펼칠 때마다 창 크기가 바뀌므로 그때마다 다시
/// 정한다(접힌 바깥 화면 = 세로 고정, 펼친 안쪽 화면 = 자유 회전).
///
/// Android 16(targetSdk 36) 이상은 큰 화면에서 앱의 방향 고정을 어차피 무시한다.
final class OrientationPolicy() with WidgetsBindingObserver {
  static final OrientationPolicy instance = OrientationPolicy();

  bool _installed = false;
  bool? _locked;

  /// 동영상 플레이어의 "가로로 보기". 켜져 있는 동안은 창 크기 정책을 적용하지 않는다.
  bool _landscapeOverride = false;

  /// 지금 화면에 맞춰 적용하고, 이후 창 크기가 바뀌면 다시 적용한다.
  /// 여러 번 불려도 관찰자는 한 번만 붙는다.
  Future<void> install() async {
    if (!_installed) {
      _installed = true;
      WidgetsBinding.instance.addObserver(this);
    }
    await _apply();
  }

  @override
  void didChangeMetrics() => _apply();

  /// 동영상을 가로로 본다. 끄면 시스템 바를 되돌리고 원래 정책(폰 세로 고정)을 다시 적용한다.
  Future<void> setLandscapeOverride(bool on) async {
    if (_landscapeOverride == on) return;
    _landscapeOverride = on;
    try {
      if (on) {
        await SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        _locked = null;
        await _apply();
      }
    } catch (e, st) {
      MoclLogger.e('가로 보기 전환 실패', error: e, stackTrace: st);
    }
  }

  Future<void> _apply() async {
    if (_landscapeOverride) return;
    final Iterable<FlutterView> views =
        WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return;
    final bool lock = !_isLargeScreen(views.first);
    if (_locked == lock) return;
    _locked = lock;
    try {
      await SystemChrome.setPreferredOrientations(
        lock
            ? const [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]
            : const <DeviceOrientation>[],
      );
    } catch (e, st) {
      MoclLogger.e('화면 방향 설정 실패', error: e, stackTrace: st);
    }
  }

  /// 짧은 변이 600dp 이상이면 큰 화면으로 본다.
  ///
  /// Android 는 창 크기만 본다. 폴드는 접어도 디스플레이 정보가 안쪽 화면
  /// 크기로 남을 수 있고, 분할 화면에서는 시스템이 방향 요청을 무시한다.
  /// iOS 는 디스플레이도 본다. iPad 분할 화면 · Slide Over 처럼 창만 좁아진
  /// 경우에도 기기는 태블릿이라 방향을 묶으면 안 된다.
  static bool _isLargeScreen(FlutterView view) {
    final double dpr = view.devicePixelRatio;
    if (dpr <= 0) return false;
    double shortest = view.physicalSize.shortestSide / dpr;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        shortest = math.max(
          shortest,
          view.display.size.shortestSide / view.display.devicePixelRatio,
        );
      } catch (_) {
        // 디스플레이 정보가 없으면 창 크기만 본다.
      }
    }
    return shortest >= WindowSize.mediumMin;
  }
}
