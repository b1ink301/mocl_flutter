import 'package:mocl_shared/util/reply_count.dart';
import 'package:test/test.dart';

void main() {
  test('숫자 · 괄호 · 쉼표를 읽는다', () {
    expect(parseReplyCount('12'), 12);
    expect(parseReplyCount(' [12] '), 12);
    expect(parseReplyCount('(1,024)'), 1024);
    expect(parseReplyCount('0'), 0);
  });

  test('정확한 수가 아니면 null', () {
    expect(parseReplyCount(''), isNull);
    expect(parseReplyCount('1.2k'), isNull);
    expect(parseReplyCount('99+'), isNull);
    expect(parseReplyCount('1만'), isNull);
    expect(parseReplyCount('-3'), isNull);
  });
}
