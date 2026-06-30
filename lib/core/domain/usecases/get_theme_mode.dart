import 'package:flutter/material.dart' show ThemeMode;
import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class GetThemeMode implements UseCase<ThemeMode, void> {
  final SettingsRepository settingsRepository;

  const GetThemeMode({required this.settingsRepository});

  @override
  ThemeMode call(void params) => settingsRepository.getThemeMode();
}
