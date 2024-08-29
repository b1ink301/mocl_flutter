enum SiteType {
  clien,
  damoang,
  none,
}

extension SiteTypeExtension on SiteType {
  String get title {
    switch (this) {
      case SiteType.clien:
        return '클리앙';
      case SiteType.damoang:
        return '다모앙';
      case SiteType.none:
        return '';
    }
  }
}