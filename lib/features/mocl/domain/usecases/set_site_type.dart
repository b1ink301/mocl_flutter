import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

@injectable
class SetSiteType implements UseCase<void, SiteType> {
  final SettingsRepository settingsRepository;

  const SetSiteType({required this.settingsRepository});

  @override
  void call(
    SiteType params,
  ) =>
      settingsRepository.setSiteType(params);
}
