/// 2단 게시판(컨테이너 → 하위 메뉴)을 평면 키 하나로 표현하는 규칙.
///
/// 즐겨찾기는 `siteType + board` 조합을 유일 키로 쓴다(favorite_providers 의
/// `_keyOf`). 하위 메뉴까지 담으려면 키가 한 칸 더 필요한데, 필드를 늘리면
/// sembast 에 이미 쌓인 레코드를 전부 마이그레이션해야 한다. 그래서 하위
/// 메뉴는 `board` 를 `'부모/자식'` 합성 키로 저장해 기존 유일성을 그대로 쓴다.
///
/// 전 사이트의 `board_link.json` 및 실시간 파싱 결과에 `/` 를 포함하는 board
/// 값은 없다(테스트로 고정). 규칙을 여기 한 곳에만 두고, URL 빌더는 반드시
/// [splitBoard] 를 거쳐 부모/자식을 분리해서 쓴다.
library;

const String _separator = '/';

/// 부모 board 와 자식 키를 합성 board 키로 만든다.
String joinBoard(String parent, String child) => '$parent$_separator$child';

/// 합성 board 키를 부모와 자식으로 나눈다.
/// 합성 키가 아니면 [child] 가 null 이다(= 단일 게시판/컨테이너 전체글).
({String parent, String? child}) splitBoard(String board) {
  final int index = board.indexOf(_separator);
  if (index <= 0 || index == board.length - 1) {
    return (parent: board, child: null);
  }
  return (
    parent: board.substring(0, index),
    child: board.substring(index + 1),
  );
}

/// 합성 board 키(= 하위 메뉴)인지.
bool isSubBoard(String board) => splitBoard(board).child != null;
