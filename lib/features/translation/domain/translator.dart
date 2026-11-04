/// 문장 목록을 한 번에 번역한다. 결과는 [texts] 와 같은 순서 · 같은 길이다.
abstract interface class Translator() {
  /// 이 기기에서 번역을 쓸 수 있는지(OS 버전 · 플랫폼).
  Future<bool> isSupported();

  Future<List<String>> translate(
    List<String> texts, {
    String from = 'en',
    String to = 'ko',
  });
}
