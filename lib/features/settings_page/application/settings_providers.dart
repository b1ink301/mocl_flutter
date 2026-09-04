import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/settings_page/application/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'datasource_provider.dart';

part 'settings_providers.g.dart';

@riverpod
class SizeCacheDirNotifier() extends _$SizeCacheDirNotifier {
  @override
  Future<String> build() async => await _getSizeCacheDir();

  Future<void> clear() async {
    state = const AsyncLoading();
    await ref.read(clearDataProvider.future);
    state = await AsyncValue.guard(_getSizeCacheDir);

    MoclLogger.log('clear cache = $state');
  }

  Future<String> _getSizeCacheDir() async =>
      await NickImageWidget.getSizeCacheDir();
}

@Riverpod(keepAlive: true)
class ShowNickImageNotifier() extends _$ShowNickImageNotifier {
  @override
  bool build() {
    final settings = ref.watch(settingsRepositoryProvider);
    return settings.isShowNickImage();
  }

  void toggle() {
    final settings = ref.read(settingsRepositoryProvider);
    state = !state;
    settings.setShowNickImage(state);
  }
}

/// 메인 게시판 목록에 사이트 아이콘을 보일지. 끄면 제목만 남아 목록이
/// 담백해지고 한 줄 높이도 낮아진다.
@Riverpod(keepAlive: true)
class ShowBoardIconNotifier() extends _$ShowBoardIconNotifier {
  @override
  bool build() {
    final settings = ref.watch(settingsRepositoryProvider);
    return settings.isShowBoardIcon();
  }

  void toggle() {
    final settings = ref.read(settingsRepositoryProvider);
    state = !state;
    settings.setShowBoardIcon(state);
  }
}

/// 메인 화면 오른쪽의 사이트 빠른 이동 레일을 보일지. 등록한 게시판이
/// 적어 스크롤이 짧다면 꺼서 화면을 넓게 쓸 수 있다.
@Riverpod(keepAlive: true)
class ShowQuickJumpNotifier() extends _$ShowQuickJumpNotifier {
  @override
  bool build() {
    final settings = ref.watch(settingsRepositoryProvider);
    return settings.isShowQuickJump();
  }

  void toggle() {
    final settings = ref.read(settingsRepositoryProvider);
    state = !state;
    settings.setShowQuickJump(state);
  }
}
