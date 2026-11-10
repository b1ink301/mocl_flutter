import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';

/// 지금 재생 중인 영상 하나.
///
/// 플레이어는 라우트가 아니라 앱 화면 위 한 층(`MediaPlayerHost`)에 있어서, 게시판을
/// 오가도 재생이 이어진다. [expanded] 는 펼침(화면 전체) ↔ 미니(떠 있는 작은 창).
final class const MediaSession({
  /// 세션마다 다른 값. 같은 링크를 다시 열어도 플레이어를 새로 만들게 key 로 쓴다.
  required final int id,
  required final VideoLink link,

  /// 영상 파일을 받을 때 실어 보낼 Referer(보통 지금 사이트 주소).
  final String? referer,
  final bool expanded = true,

  /// "가로로 보기". 펼침일 때만 켜진다.
  final bool landscape = false,
}) {
  MediaSession copyWith({bool? expanded, bool? landscape}) => MediaSession(
    id: id,
    link: link,
    referer: referer,
    expanded: expanded ?? this.expanded,
    landscape: landscape ?? this.landscape,
  );
}
