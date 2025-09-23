import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/settings_page/domain/repositories/settings_repository.dart';

class InitFontSize implements UseCase<void, void> {
  final SettingsRepository settingsRepository;

  const InitFontSize({required this.settingsRepository});

  @override
  void call(void params) => settingsRepository.setFontSize(0);
}
