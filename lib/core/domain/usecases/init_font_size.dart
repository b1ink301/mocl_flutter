import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class const InitFontSize({required final SettingsRepository settingsRepository})
    implements UseCase<void, void> {
  @override
  void call(void params) => settingsRepository.setFontSize(0);
}
