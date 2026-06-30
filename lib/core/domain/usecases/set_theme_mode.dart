import 'package:flutter/material.dart' show ThemeMode;
import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class SetThemeMode implements UseCase<void, ThemeMode> {
  final SettingsRepository settingsRepository;

  const SetThemeMode({required this.settingsRepository});

  @override
  void call(ThemeMode params) => settingsRepository.setThemeMode(params);
}
