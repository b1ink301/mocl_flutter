import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class GetFontSize implements UseCase<double, void> {
  final SettingsRepository settingsRepository;

  const GetFontSize({required this.settingsRepository});

  @override
  double call(void params) => settingsRepository.getFontSize();
}
