import 'package:mocl_flutter/features/settings_page/data/repositories/mocl_settings_repository_impl.dart';
import 'package:mocl_flutter/features/settings_page/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'datasource_provider.dart';

part 'repository_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(prefs: ref.watch(sharedPreferencesProvider));
