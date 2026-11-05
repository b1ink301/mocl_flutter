import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 레이더가 보는 게시판 하나.
class const RadarBoard({
  required final SiteType site,
  required final String board,
  required final String url,
  required final String title,

  /// 점수 가중치. 베스트 게시판 1.0, 자유게시판류(노이즈 많음)는 낮게.
  final double weight = 1.0,
}) {
  String get key => '${site.name}|$board';
}

/// 레이더 수집 게시판(2026-11-05 오라클 IP 에서 받아 보고 정함).
///
/// 더쿠 · 루리웹 · 아카라이브 · 인스티즈는 서버 IP 를 막아 없다. 뽐뿌는 핫딜이라 뺐다.
/// 정렬은 모두 최신순 — 이슈를 찾으려면 새 글을 빠짐없이 봐야 한다(추천순은
/// 클리앙만 다르게 주고, 다모앙은 빈 목록이다).
const List<RadarBoard> radarBoards = [
  RadarBoard(
    site: SiteType.dcinside,
    board: 'dcbest',
    url: 'https://m.dcinside.com/board/dcbest',
    title: '실시간 베스트',
  ),
  RadarBoard(
    site: SiteType.nate,
    board: 'ranking',
    url: 'https://m.pann.nate.com/talk/ranking',
    title: '실시간 인기톡',
  ),
  RadarBoard(
    site: SiteType.bobaedream,
    board: 'best',
    url: 'https://m.bobaedream.co.kr/board/new_writing/best',
    title: '베스트글',
  ),
  RadarBoard(
    site: SiteType.dogdrip,
    board: 'boomupbest',
    url: 'https://www.dogdrip.net/boomupbest',
    title: '붐업 베스트',
  ),
  RadarBoard(
    site: SiteType.inven,
    board: '2097',
    url: 'https://m.inven.co.kr/board/webzine/2097',
    title: '오픈이슈갤러리',
    weight: 0.8,
  ),
  RadarBoard(
    site: SiteType.geekNews,
    board: '',
    url: 'https://news.hada.io/',
    title: '긱뉴스',
    weight: 0.8,
  ),
  RadarBoard(
    site: SiteType.clien,
    board: 'park',
    url: 'https://m.clien.net/service/board/park',
    title: '모두의공원',
    weight: 0.7,
  ),
  RadarBoard(
    site: SiteType.damoang,
    board: 'free',
    url: 'https://damoang.net/free',
    title: '자유게시판',
    weight: 0.7,
  ),
  RadarBoard(
    site: SiteType.mlbpark,
    board: 'bullpen',
    url: 'https://mlbpark.donga.com/mp/b.php?b=bullpen',
    title: '불펜',
    weight: 0.7,
  ),
  RadarBoard(
    site: SiteType.meeco,
    board: 'free',
    url: 'https://meeco.kr/free',
    title: '자유 게시판',
    weight: 0.5,
  ),
  RadarBoard(
    site: SiteType.cook82,
    board: '15',
    url: 'https://www.82cook.com/entiz/enti.php?bn=15',
    title: '자유게시판',
    weight: 0.5,
  ),
];
