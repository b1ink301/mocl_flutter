import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

class GetSiteType extends UseCase<Future<SiteType>, void> {
  final SettingsRepository settingsRepository;

  GetSiteType({required this.settingsRepository});

  @override
  Future<SiteType> call(void params) => settingsRepository.getSiteType();
}
