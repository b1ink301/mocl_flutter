import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

class GetSiteType extends UseCaseNoFuture<SiteType, NoParams> {
  final SettingsRepository settingsRepository;

  GetSiteType({required this.settingsRepository});

  @override
  SiteType call(NoParams params) => settingsRepository.getSiteType();
}
