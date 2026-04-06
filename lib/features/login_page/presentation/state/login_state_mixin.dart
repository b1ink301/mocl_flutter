import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

mixin class LoginState {
  SiteType siteTypeState(WidgetRef ref) => ref.watch(currentSiteTypeProvider);
}
