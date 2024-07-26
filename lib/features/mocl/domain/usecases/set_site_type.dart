import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

class SetSiteType extends UseCaseNoFuture<void, SiteType> {
  final SettingsRepository settingsRepository;

  SetSiteType({required this.settingsRepository});

  @override
  void call(
    SiteType params,
  ) =>
      settingsRepository.setSiteType(params);
}
