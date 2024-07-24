import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

const EXTRA_SITE_TYPE = 'site_type';

abstract class SettingsRepository {
  SiteType getSiteType();
  void setSiteType(SiteType siteType);
}