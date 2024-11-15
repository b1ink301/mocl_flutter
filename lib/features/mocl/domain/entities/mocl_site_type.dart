enum SiteType {
  clien,
  damoang,
  meeco,
  naverCafe,
  settings,
}

extension SiteTypeExtension on SiteType {
  String get title {
    switch (this) {
      case SiteType.clien:
        return '클리앙';
      case SiteType.damoang:
        return '다모앙';
      case SiteType.settings:
        return '설정';
      case SiteType.meeco:
        return '미코';
      case SiteType.naverCafe:
        return '네이버카페';
    }
  }
}
