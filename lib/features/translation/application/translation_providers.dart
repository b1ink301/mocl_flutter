import 'package:mocl_flutter/features/translation/data/platform_translator.dart';
import 'package:mocl_flutter/features/translation/domain/translator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'translation_providers.g.dart';

@Riverpod(keepAlive: true)
Translator translator(Ref ref) => const PlatformTranslator();

/// 이 기기에서 번역을 쓸 수 있는지. 앱이 떠 있는 동안 바뀌지 않으므로 한 번만 묻는다.
@Riverpod(keepAlive: true)
Future<bool> translationAvailable(Ref ref) =>
    ref.watch(translatorProvider).isSupported();
