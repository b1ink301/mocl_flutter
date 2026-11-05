/// "방금 · n분 전 · n시간 전 · n일 전". 레이더 시각은 서버가 처음 본 시각이다.
String issueTimeAgo(int at, {DateTime? now}) {
  final Duration d = (now ?? DateTime.now()).difference(
    DateTime.fromMillisecondsSinceEpoch(at),
  );
  if (d.inMinutes < 1) return '방금';
  if (d.inMinutes < 60) return '${d.inMinutes}분 전';
  if (d.inHours < 24) return '${d.inHours}시간 전';
  return '${d.inDays}일 전';
}
