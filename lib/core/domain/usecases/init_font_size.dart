import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class InitFontSize implements UseCase<void, void> {
  final SettingsRepository settingsRepository;

  const InitFontSize({required this.settingsRepository});

  @override
  void call(void params) => settingsRepository.setFontSize(0);
}
