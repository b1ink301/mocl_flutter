import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/app_entry/domain/shared_text.dart';

void main() {
  group('SharedText.firstUrl', () {
    test('주소만 보낸 경우', () {
      expect(
        SharedText.firstUrl('https://m.clien.net/service/board/park/123'),
        'https://m.clien.net/service/board/park/123',
      );
    });

    test('제목과 주소를 함께 보낸 경우 첫 주소', () {
      expect(
        SharedText.firstUrl(
          '재밌는 글\nhttps://damoang.net/free/42 https://x.com/a',
        ),
        'https://damoang.net/free/42',
      );
    });

    test('끝 문장부호 · 짝 없는 괄호는 뗀다', () {
      expect(
        SharedText.firstUrl('여기(https://damoang.net/free/42).'),
        'https://damoang.net/free/42',
      );
      expect(
        SharedText.firstUrl('https://en.wikipedia.org/wiki/Foo_(bar)'),
        'https://en.wikipedia.org/wiki/Foo_(bar)',
      );
    });

    test('쿼리는 그대로', () {
      expect(
        SharedText.firstUrl(
          'https://www.82cook.com/entiz/read.php?bn=15&num=1',
        ),
        'https://www.82cook.com/entiz/read.php?bn=15&num=1',
      );
    });

    test('주소가 없으면 null', () {
      expect(SharedText.firstUrl('그냥 글'), isNull);
      expect(SharedText.firstUrl('https://'), isNull);
    });
  });
}
