enum SiteType {
  arcalive,
  bobaedream,
  clien,
  cook82,
  damoang,
  dcinside,
  dogdrip,
  geekNews,
  inven,
  meeco,
  naverCafe,
  ppomppu,
  reddit,
  ruliweb,
  theqoo,
  settings,
}

extension SiteTypeExtension on SiteType {
  String get title => switch (this) {
        SiteType.arcalive => '아카라이브',
        SiteType.bobaedream => '보배드림',
        SiteType.clien => '클리앙',
        SiteType.cook82 => '82쿡',
        SiteType.dcinside => '디시인사이드',
        SiteType.dogdrip => '개드립',
        SiteType.damoang => '다모앙',
        SiteType.geekNews => '긱뉴스',
        SiteType.inven => '인벤',
        SiteType.settings => '설정',
        SiteType.meeco => '미코',
        SiteType.naverCafe => '네이버카페',
        SiteType.ppomppu => '뽐뿌',
        SiteType.reddit => '레딧',
        SiteType.ruliweb => '루리웹',
        SiteType.theqoo => '더쿠',
      };

  /// 로그인(계정) 연동을 지원하는 사이트인지. 긱뉴스는 계정이 없고,
  /// settings 는 사이트가 아니므로 제외한다.
  bool get supportsLogin => switch (this) {
        SiteType.geekNews || SiteType.settings => false,
        _ => true,
      };
}
