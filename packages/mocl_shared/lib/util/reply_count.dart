/// 목록의 댓글 수 문자열(`ListItem.reply`)을 정수로 읽는다.
///
/// 사이트마다 `12` · `[12]` · `(1,024)` 처럼 달라서 괄호와 쉼표만 걷어 낸다.
/// `1.2k` · `99+` · `1만` 처럼 정확한 수가 아니면 null — 그런 글은 새 댓글을
/// 세지 않는다(틀린 `+N` 보다 안 보이는 쪽이 낫다).
int? parseReplyCount(String reply) {
  final String s = reply.trim().replaceAll(RegExp(r'[\[\]\(\),\s]'), '');
  if (s.isEmpty || !_digits.hasMatch(s)) return null;
  return int.tryParse(s);
}

final RegExp _digits = RegExp(r'^\d{1,9}$');
