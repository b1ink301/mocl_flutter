import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

/// 사이트를 성격별로 묶은 기본 카테고리.
/// 드로어의 사이트 목록 구성과, 즐겨찾기 그룹의 기본값(새로 추가한 게시판이
/// 어느 그룹으로 들어갈지) 양쪽에서 같은 정의를 공유한다.
/// (전체 18개 사이트를 빠짐없이 포함해야 한다)
typedef SiteCategory = ({String id, String label, List<SiteType> sites});

const List<SiteCategory> kSiteCategories = [
  (
    id: 'community',
    label: '커뮤니티',
    sites: [
      SiteType.clien,
      SiteType.damoang,
      SiteType.arcalive,
      SiteType.cook82,
      SiteType.ppomppu,
      SiteType.instiz,
      SiteType.theqoo,
      SiteType.meeco,
      SiteType.nate,
      SiteType.naverCafe,
    ],
  ),
  (
    id: 'hobby',
    label: '취미 · 자동차 · 게임',
    sites: [
      SiteType.bobaedream,
      SiteType.inven,
      SiteType.ruliweb,
      SiteType.dogdrip,
    ],
  ),
  (
    id: 'news',
    label: '뉴스 · IT · 스포츠',
    sites: [SiteType.geekNews, SiteType.dcinside, SiteType.mlbpark],
  ),
  (id: 'global', label: '해외', sites: [SiteType.reddit]),
];

/// 카테고리 순서대로 펼친 전체 사이트 목록.
/// 게시판 추가 화면의 사이트 레일이 이 순서로 그린다(성격이 비슷한 사이트끼리
/// 이웃하게 두어 훑기 쉽게).
final List<SiteType> kAllSitesInOrder = [
  for (final SiteCategory category in kSiteCategories) ...category.sites,
];
