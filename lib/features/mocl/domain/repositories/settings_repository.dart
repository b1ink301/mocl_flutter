import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

abstract class SettingsRepository {
  SiteType getSiteType();
  void setSiteType(SiteType siteType);
}