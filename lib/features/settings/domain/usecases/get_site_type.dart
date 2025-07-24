import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/settings/domain/repositories/settings_repository.dart';

class GetSiteType implements UseCase<SiteType, void> {
  final SettingsRepository settingsRepository;

  const GetSiteType({required this.settingsRepository});

  @override
  SiteType call(void params) => settingsRepository.getSiteType();
}
