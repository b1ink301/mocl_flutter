import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'clear_data_state.dart';
part 'clear_data_cubit.freezed.dart';

@injectable
class ClearDataCubit extends Cubit<ClearDataState> {
  ClearDataCubit() : super(const ClearDataState.initial());

  Future<void> clearData() async {
    emit(const ClearDataState.loading());
    DefaultCacheManager().emptyCache();

    var webViewController = WebViewController();
    await webViewController.clearCache();
    await webViewController.clearLocalStorage();

    await Future.delayed(Duration(milliseconds: 300));
    emit(const ClearDataState.success());
  }
}
