import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/settings/domain/repositories/settings_repository.dart';

class SetSiteType implements UseCase<void, SiteType> {
  final SettingsRepository settingsRepository;

  const SetSiteType({required this.settingsRepository});

  @override
  void call(SiteType params) => settingsRepository.setSiteType(params);
}
