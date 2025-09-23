import 'package:mocl_flutter/core/usecases/usecase.dart';

import '../repositories/settings_repository.dart';

class GetFontSize implements UseCase<double, void> {
  final SettingsRepository settingsRepository;

  const GetFontSize({required this.settingsRepository});

  @override
  double call(void params) => settingsRepository.getFontSize();
}
