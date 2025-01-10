import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

@riverpod
class ClearDataNotifier extends _$ClearDataNotifier {
  @override
  Future<bool> build() async => false;

  Future<void> clear() async {
    state = const AsyncLoading();
    await AsyncValue.guard(() => ref.read(clearDataProvider.future));
    state = const AsyncData(true);
  }
}
