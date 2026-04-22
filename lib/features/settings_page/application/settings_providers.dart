import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/settings_page/application/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'datasource_provider.dart';

part 'settings_providers.g.dart';

@riverpod
class SizeCacheDirNotifier extends _$SizeCacheDirNotifier {
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
class ShowNickImageNotifier extends _$ShowNickImageNotifier {
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
