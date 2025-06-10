import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

extension SortTypeExtension on SortType {
  String toQuery(SiteType siteType) {
    switch (siteType) {
      case SiteType.clien:
        return switch (this) {
          SortType.recent => '&od=T31',
          SortType.recommend => '&od=T33',
        };
      case SiteType.damoang:
        switch (this) {
          case SortType.recent:
            return '';
          case SortType.recommend:
            final now = DateTime.now();
            final today =
                '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
            return '&&sfl=wr_datetime&sst=wr_good&stx=$today';
        }
      case SiteType.meeco:
        return '';
      case SiteType.naverCafe:
        return '';
      case SiteType.settings:
        return '';
      case SiteType.reddit:
        return switch (this) {
          SortType.recent => 'new',
          SortType.recommend => 'hot',
        };
      case SiteType.theqoo:
        return '';
    }
  }
}

extension StringExtension on String {
  String toUrl(String baseUrl) =>
      isNotEmpty && !startsWith("http") ? '$baseUrl$this' : this;
}
