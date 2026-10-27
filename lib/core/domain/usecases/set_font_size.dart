import 'package:dartx/dartx.dart';
import 'package:mocl_flutter/core/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

class const SetFontSize({required final SettingsRepository settingsRepository})
    implements UseCase<double, double> {
  @override
  double call(double params) {
    final double current = settingsRepository.getFontSize();
    final double next = (current + params).coerceIn(-5.0, 10.0);
    if (next != current) {
      settingsRepository.setFontSize(next);
    }
    return next;
  }
}
