import 'package:mocl_flutter/features/settings_page/application/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/usecases/get_font_size.dart';
import '../domain/usecases/get_site_type.dart';
import '../domain/usecases/get_theme_mode.dart';
import '../domain/usecases/init_font_size.dart';
import '../domain/usecases/set_font_size.dart';
import '../domain/usecases/set_site_type.dart';
import '../domain/usecases/set_theme_mode.dart';

part 'use_case_provider.g.dart';

@riverpod
GetSiteType getSiteType(Ref ref) =>
    GetSiteType(settingsRepository: ref.watch(settingsRepositoryProvider));

@riverpod
SetSiteType setSiteType(Ref ref) =>
    SetSiteType(settingsRepository: ref.watch(settingsRepositoryProvider));

@riverpod
SetFontSize setFontSize(Ref ref) =>
    SetFontSize(settingsRepository: ref.watch(settingsRepositoryProvider));

@riverpod
GetFontSize getFontSize(Ref ref) =>
    GetFontSize(settingsRepository: ref.watch(settingsRepositoryProvider));

@riverpod
InitFontSize initFontSize(Ref ref) =>
    InitFontSize(settingsRepository: ref.watch(settingsRepositoryProvider));

@riverpod
GetThemeMode getThemeMode(Ref ref) =>
    GetThemeMode(settingsRepository: ref.watch(settingsRepositoryProvider));

@riverpod
SetThemeMode setThemeMode(Ref ref) =>
    SetThemeMode(settingsRepository: ref.watch(settingsRepositoryProvider));
