import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class const GetFontSize({required final SettingsRepository settingsRepository})
    implements UseCase<double, void> {
  @override
  double call(void params) => settingsRepository.getFontSize();
}
