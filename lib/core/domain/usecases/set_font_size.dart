import 'package:dartx/dartx.dart';
import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class SetFontSize implements UseCase<void, double> {
  final SettingsRepository settingsRepository;

  const SetFontSize({required this.settingsRepository});

  @override
  void call(double params) {
    double currentFontSize = settingsRepository.getFontSize();
    currentFontSize += params;
    currentFontSize = currentFontSize.coerceIn(-5.0, 10.0);
    settingsRepository.setFontSize(currentFontSize);
  }
}
