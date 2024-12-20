import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'clear_data_cubit.freezed.dart';

part 'clear_data_state.dart';

@injectable
class ClearDataCubit extends Cubit<ClearDataState> {
  ClearDataCubit() : super(const ClearDataState.initial());

  Future<void> clearData() async {
    emit(const ClearDataState.loading());
    DefaultCacheManager().emptyCache();

    await InAppWebViewController.clearAllCache();

    // CookieManager.instance().deleteAllCookies();
    await Future.delayed(Duration(milliseconds: 300));
    emit(const ClearDataState.success());
  }
}
