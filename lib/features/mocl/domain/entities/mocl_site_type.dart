enum SiteType {
  clien,
  damoang,
  meeco,
  naverCafe,
  reddit,
  settings,
}

extension SiteTypeExtension on SiteType {
  String get title => switch (this) {
        SiteType.clien => '클리앙',
        SiteType.damoang => '다모앙',
        SiteType.settings => '설정',
        SiteType.meeco => '미코',
        SiteType.naverCafe => '네이버카페',
        SiteType.reddit => '레딧'
      };
}
