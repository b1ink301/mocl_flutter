import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../../domain/entities/mocl_result.dart';
import '../../../../domain/usecases/set_main_list.dart';
import '../../../../domain/usecases/set_site_type.dart';
import '../../../injection.dart';

part 'main_provider.g.dart';

// @riverpod
// FutureOr<Result> getMain(GetMainRef ref) {
//   final siteType = ref.watch(currentSiteTypeStateProvider);
//   return getIt<GetMainList>().call(siteType);
// }

@riverpod
FutureOr<Result> getMainDialog(GetMainDialogRef ref) {
  final siteType = ref.watch(currentSiteTypeStateProvider);
  return getIt<GetMainListFromJson>().call(siteType);
}

@Riverpod(keepAlive: true)
class MainListState extends _$MainListState {
  @override
  FutureOr<Result> build() => _getList();

  void reload() {
    state = const AsyncValue.loading(); // 로딩 상태 설정

    _getList().then((result) {
      state = AsyncValue.data(result);
    }).catchError((error) {
      state = AsyncValue.error(error, StackTrace.current);
    });
  }

  Future<void> setList(List<MainItem> items) async {
    final siteType = ref.watch(currentSiteTypeStateProvider);
    final param = SetMainParams(siteType: siteType, list: items);
    await getIt<SetMainList>().call(param);

    reload();
  }

  Future<Result> _getList() {
    final siteType = ref.watch(currentSiteTypeStateProvider);
    return getIt<GetMainList>().call(siteType);
  }
}

// @Riverpod(keepAlive: true)
// class CurrentSiteType extends _$CurrentSiteType {
//   @override
//   SiteType build() => _fetchSiteType();
//
//   SiteType _fetchSiteType() {
//     final getSiteType = getIt<GetSiteType>();
//     return getSiteType(NoParams());
//   }
//
//   void setSiteType(SiteType newSiteType) {
//     final setSiteType = getIt<SetSiteType>();
//     setSiteType(newSiteType);
//     state = newSiteType;
//   }
// }

@riverpod
String mainTitle(MainTitleRef ref) {
  final siteType = ref.watch(currentSiteTypeStateProvider);
  return siteType.title;
}

// final currentSiteTypeProvider = StateProvider<SiteType>((ref) {
//   final getSiteType = getIt<GetSiteType>();
//   return getSiteType(NoParams());
// });

@riverpod
SiteType currentSiteType(CurrentSiteTypeRef ref) {
  final getSiteType = getIt<GetSiteType>();
  return getSiteType(NoParams());
}

// @riverpod
// void changeSiteType(ChangeSiteTypeRef ref, SiteType newSiteType) {
//   final siteType = ref.read(currentSiteTypeProvider);
//   if (siteType != newSiteType) {
//     ref.read(currentSiteTypeProvider.notifier).state = newSiteType;
//     final setSiteType = getIt<SetSiteType>();
//     setSiteType(newSiteType);
//   }
// }

@Riverpod(keepAlive: true)
class CurrentSiteTypeState extends _$CurrentSiteTypeState {
  @override
  SiteType build() => _getSiteType();

  SiteType _getSiteType() {
    final getSiteType = getIt<GetSiteType>();
    return getSiteType(NoParams());
  }

  void setSiteType(SiteType newSiteType) {
    if (state != newSiteType) {
      final setSiteType = getIt<SetSiteType>();
      setSiteType(newSiteType);
      state = newSiteType;
    }
  }
}

// @riverpod
// SiteType changeSiteTypeState(ChangeSiteTypeStateRef ref) {
//   final siteType = ref.watch(currentSiteTypeProvider);
//
//   ref.listen<SiteType>(currentSiteTypeProvider, (_, newSiteType) {
//     if (newSiteType != siteType) {
//       final setSiteType = getIt<SetSiteType>();
//       setSiteType(newSiteType);
//       ref.state = newSiteType;
//     }
//   });
//
//   return siteType;
// }
