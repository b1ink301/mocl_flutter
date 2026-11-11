import 'package:test/test.dart';
import 'package:mocl_shared/parser/damoang/damoang_parser.dart';

void main() {
  String n(String s) => DamoangParser.normalizeContentHtml(s);

  test('bracket-image 숏코드를 img 로 바꾼다', () {
    const url =
        'https://static.klipy.com/ii/c3a19a0b747a76e98651f2b9a3cca5ff/71/1a/yLso0ESk.gif';
    final out = n('<p>[$url]</p>');
    expect(out, contains('<img src="$url"'));
    expect(out, contains('class="bracket-image"'));
    expect(out, isNot(contains('[http')));
  });

  test('링크로 감싼 대괄호 숏코드도 바꾼다', () {
    final out = n(
      '<p>[<a href="https://a.com/b.jpg?x=1" rel="nofollow">https://a.com/b.jpg?x=1</a>]</p>',
    );
    expect(out, contains('<img src="https://a.com/b.jpg?x=1"'));
  });

  test('이모티콘 토큰: 기본/접두사/명시 폭', () {
    expect(
      n('<p>{emo:onion-012.gif}</p>'),
      contains('<img src="/emoticons/onion-012.gif" width="50"'),
    );
    expect(n('<p>{이모티콘:damoang-meme-001.gif}</p>'), contains('width="200"'));
    expect(n('<p>{emo:damoang-emo-3.png:150}</p>'), contains('width="150"'));
    expect(n('<p>{emo:x.gif:9999}</p>'), contains('width="200"'));
  });

  test('img 로 저장된 이모티콘에 폭을 넣는다', () {
    final out = n(
      '<p><img src="/emoticons/onion-013.gif" alt="onion-013.gif"></p>',
    );
    expect(out, contains('width="50"'));
    expect(out, contains('class="emoticon-inline"'));
    expect(out, contains('src="/emoticons/onion-013.gif"'));
    expect(
      n('<img src="https://damoang.net/emoticons/damoang-meme-1.gif">'),
      contains('width="200"'),
    );
    const sized = '<img src="/emoticons/a.gif" width="30">';
    expect(n(sized), sized);
    const photo = '<img src="https://cdn.damoang.net/data/editor/a.jpg">';
    expect(n(photo), photo);
  });

  test('이상한 이모티콘 파일명은 이모지로 대체', () {
    expect(n('<p>{emo:../../etc/passwd}</p>'), '<p>😀</p>');
  });

  test('이미지가 아닌 대괄호/URL 은 건드리지 않는다', () {
    const src = '<p>목록[1] 참고 https://a.com/c.txt</p>';
    expect(n(src), src);
  });
}
