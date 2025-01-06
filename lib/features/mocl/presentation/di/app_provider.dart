import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.g.dart';

final localeCodeProvider = StateProvider<String>((ref) => 'ko');

@riverpod
class CurrentSiteType extends _$CurrentSiteType {
  @override
  SiteType build() {
    final getSiteType = ref.watch(getSiteTypeProvider);
    return getSiteType(NoParams());
  }

  void changeSiteType(SiteType newSiteType) {
    if (state != newSiteType) {
      final setSiteType = ref.read(setSiteTypeProvider);
      setSiteType(newSiteType);
      state = newSiteType;
    }
  }
}

@riverpod
FutureOr<String> getAppVersion(Ref ref) async {
  final info = await PackageInfo.fromPlatform();
  final version = 'v${info.version}-${info.buildNumber}';
  return version;
}
