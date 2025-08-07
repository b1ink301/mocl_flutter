import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/di/repository_provider.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';


@riverpod
class SizeCacheDirNotifier extends _$SizeCacheDirNotifier {
  @override
  Future<String> build() async => await _getSizeCacheDir();

  Future<void> clear() async {
    state = const AsyncLoading();
    await ref.read(clearDataProvider.future);
    state = await AsyncValue.guard(() => _getSizeCacheDir());

    debugPrint('clear cache = $state');
  }

  Future<String> _getSizeCacheDir() async =>
      await NickImageWidget.getSizeCacheDir();
}

@riverpod
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
