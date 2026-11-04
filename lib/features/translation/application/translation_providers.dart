import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:mocl_flutter/features/translation/data/platform_translator.dart';
import 'package:mocl_flutter/features/translation/domain/html_text_translator.dart';
import 'package:mocl_flutter/features/translation/domain/translator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'translation_providers.g.dart';

@Riverpod(keepAlive: true)
Translator translator(Ref ref) => const PlatformTranslator();

/// 이 기기에서 번역을 쓸 수 있는지. 앱이 떠 있는 동안 바뀌지 않으므로 한 번만 묻는다.
@Riverpod(keepAlive: true)
Future<bool> translationAvailable(Ref ref) =>
    ref.watch(translatorProvider).isSupported();

/// 이 사이트에 번역 버튼을 둘지. 사이트가 켜 두었고(레딧) 기기가 지원해야 한다.
///
/// 저장소까지 만들면 로컬 DB 를 끌어오므로 파서에서 바로 읽는다.
@riverpod
bool siteTranslationSupported(Ref ref, SiteType siteType) =>
    ref.watch(currentParserProvider(siteType)).$1.supportsTranslation &&
    (ref.watch(translationAvailableProvider).value ?? false);

/// 목록 제목 번역 결과. 원문 제목 → 번역문.
class const TitleTranslations({
  final Map<String, String> translated = const {},

  /// 진행 중인 번역 요청 수(앱바 번역 버튼의 진행 표시).
  final int pending = 0,
});

/// 목록 제목 번역 저장소. 앱이 떠 있는 동안 유지해서, 같은 제목은 게시판을
/// 다시 열거나 새로고침해도 다시 번역하지 않는다.
@Riverpod(keepAlive: true)
class TitleTranslationsNotifier() extends _$TitleTranslationsNotifier {
  /// 기억해 둘 제목 수 상한. 넘으면 오래된 것부터 버린다.
  static const int _maxEntries = 3000;

  /// 번역 중인 제목. 같은 제목을 겹쳐 요청하지 않는다.
  final Set<String> _inFlight = {};

  @override
  TitleTranslations build() => const TitleTranslations();

  /// [titles] 중 아직 번역하지 않은 제목만 한 번에 번역한다. 실패하면 던진다.
  Future<void> translate(Iterable<String> titles) async {
    final List<String> todo = {
      for (final String title in titles)
        if (!state.translated.containsKey(title) &&
            !_inFlight.contains(title) &&
            HtmlTextTranslator.needsTranslation(title))
          title,
    }.toList();
    if (todo.isEmpty) return;
    _inFlight.addAll(todo);
    // 위젯 빌드 중(목록 갱신 알림 안)에 불려도 상태를 바꾸지 않도록 한 박자 쉰다.
    await Future<void>.delayed(Duration.zero);
    if (!ref.mounted) return;
    state = TitleTranslations(
      translated: state.translated,
      pending: state.pending + 1,
    );

    try {
      final List<String> out = await ref
          .read(translatorProvider)
          .translate(todo);
      if (!ref.mounted) return;
      Map<String, String> merged = {
        ...state.translated,
        for (var i = 0; i < todo.length && i < out.length; i++) todo[i]: out[i],
      };
      if (merged.length > _maxEntries) {
        merged = Map.fromEntries(
          merged.entries.skip(merged.length - _maxEntries),
        );
      }
      state = TitleTranslations(translated: merged, pending: state.pending - 1);
    } catch (_) {
      if (ref.mounted) {
        state = TitleTranslations(
          translated: state.translated,
          pending: state.pending - 1,
        );
      }
      rethrow;
    } finally {
      _inFlight.removeAll(todo);
    }
  }
}
