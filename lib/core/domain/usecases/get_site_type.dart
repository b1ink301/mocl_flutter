import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class const GetSiteType({required final SettingsRepository settingsRepository})
    implements UseCase<SiteType, void> {
  @override
  SiteType call(void params) => settingsRepository.getSiteType();
}
