import 'package:flutter/services.dart';
import 'package:mocl_flutter/features/translation/domain/translator.dart';

/// OS 내장 기기 번역을 부른다. Android 는 ML Kit(`TranslationChannel.kt`),
/// iOS · macOS 는 Apple Translation(`TranslationChannel.swift`).
/// 그 밖의 플랫폼은 채널이 없어 지원하지 않는 것으로 본다.
class const PlatformTranslator() implements Translator {
  static const MethodChannel _channel = MethodChannel(
    'net.b1ink.mocl/translation',
  );

  @override
  Future<bool> isSupported() async {
    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<List<String>> translate(
    List<String> texts, {
    String from = 'en',
    String to = 'ko',
  }) async {
    if (texts.isEmpty) return const [];
    final List<Object?>? result = await _channel.invokeMethod<List<Object?>>(
      'translate',
      {'texts': texts, 'from': from, 'to': to},
    );
    return [for (final Object? text in result ?? const []) '$text'];
  }
}
