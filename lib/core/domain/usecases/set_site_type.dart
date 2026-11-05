import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class const SetSiteType({required final SettingsRepository settingsRepository})
    implements UseCase<void, SiteType> {
  @override
  void call(SiteType params) => settingsRepository.setSiteType(params);
}
