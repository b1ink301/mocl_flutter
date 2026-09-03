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

/// 사이트가 속한 기본 카테고리 ID. 정의에 없으면 첫 카테고리로 보낸다.
String defaultCategoryIdOf(SiteType siteType) {
  for (final SiteCategory category in kSiteCategories) {
    if (category.sites.contains(siteType)) {
      return category.id;
    }
  }
  return kSiteCategories.first.id;
}
