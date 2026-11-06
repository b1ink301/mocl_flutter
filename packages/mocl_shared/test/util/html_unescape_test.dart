import 'package:mocl_shared/util/html_unescape.dart';
import 'package:test/test.dart';

void main() {
  test('기본 이름 엔티티를 푼다', () {
    expect(
      unescapeHtml('&lt;a href=&quot;x?a=1&amp;b=2&quot;&gt;&apos;&lt;/a&gt;'),
      '<a href="x?a=1&b=2">\'</a>',
    );
    expect(unescapeHtml('a&nbsp;b'), 'a b');
  });

  test('숫자 엔티티(10진 · 16진)를 푼다', () {
    expect(unescapeHtml('It&#39;s &#x200B;&#X1F600;'), "It's ​😀");
  });

  test('한 번만 푼다', () {
    expect(unescapeHtml('&amp;lt;p&amp;gt;'), '&lt;p&gt;');
  });

  test('모르는 엔티티 · 잘못된 값 · 세미콜론 없는 것은 그대로 둔다', () {
    expect(
      unescapeHtml('&hellip; &#0; &#xD800; &#99999999; &amp x'),
      '&hellip; &#0; &#xD800; &#99999999; &amp x',
    );
    expect(unescapeHtml('엔티티 없음'), '엔티티 없음');
  });
}
