import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/translation/application/translation_providers.dart';
import 'package:mocl_flutter/features/translation/domain/translator.dart';

class _FakeTranslator() implements Translator {
  final List<List<String>> calls = [];

  @override
  Future<bool> isSupported() async => true;

  @override
  Future<List<String>> translate(
    List<String> texts, {
    String from = 'en',
    String to = 'ko',
  }) async {
    calls.add(texts);
    return [for (final t in texts) '[ko]$t'];
  }
}

void main() {
  test('목록 제목은 아직 번역하지 않은 것만 한 번에 번역해 기억한다', () async {
    final translator = _FakeTranslator();
    final container = ProviderContainer(
      overrides: [translatorProvider.overrideWithValue(translator)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(titleTranslationsProvider.notifier);

    await notifier.translate(['Hello world', '한국어 제목', 'Hello world']);
    await notifier.translate(['Hello world', 'Second post']);

    expect(translator.calls, [
      ['Hello world'],
      ['Second post'],
    ]);
    final state = container.read(titleTranslationsProvider);
    expect(state.translated, {
      'Hello world': '[ko]Hello world',
      'Second post': '[ko]Second post',
    });
    expect(state.pending, 0);
  });
}
