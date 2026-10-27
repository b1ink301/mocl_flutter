import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/app_update/data/app_update_prompt_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppUpdatePromptStore store;
  final DateTime t0 = DateTime(2026, 10, 27, 12);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = AppUpdatePromptStore(await SharedPreferences.getInstance());
  });

  test('처음 보는 버전은 바로 안내한다', () {
    expect(store.shouldPrompt('391', now: t0), isTrue);
  });

  test('안내한 버전은 간격이 지나기 전까지 다시 묻지 않는다', () async {
    await store.markPrompted('391', now: t0);

    expect(
      store.shouldPrompt('391', now: t0.add(const Duration(days: 1))),
      isFalse,
    );
    expect(
      store.shouldPrompt('391', now: t0.add(AppUpdatePromptStore.interval)),
      isTrue,
    );
  });

  test('더 새 버전이 나오면 간격과 상관없이 바로 안내한다', () async {
    await store.markPrompted('391', now: t0);

    expect(
      store.shouldPrompt('392', now: t0.add(const Duration(hours: 1))),
      isTrue,
    );
  });
}
