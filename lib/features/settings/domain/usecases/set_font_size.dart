import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/settings/domain/repositories/settings_repository.dart';

class SetFontSize implements UseCase<void, double> {
  final SettingsRepository settingsRepository;

  const SetFontSize({required this.settingsRepository});

  @override
  void call(double params) => settingsRepository.setFontSize(params);
}
