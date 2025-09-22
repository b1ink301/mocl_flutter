import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/di/app_provider.dart';

mixin class LoginState {
  SiteType siteTypeState(WidgetRef ref) => ref.watch(currentSiteTypeProvider);
}
