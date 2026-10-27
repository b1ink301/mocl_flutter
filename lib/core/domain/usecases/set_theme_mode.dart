import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class const SetThemeMode({required final SettingsRepository settingsRepository})
    implements UseCase<void, ThemeMode> {
  @override
  void call(ThemeMode params) => settingsRepository.setThemeMode(params);
}
