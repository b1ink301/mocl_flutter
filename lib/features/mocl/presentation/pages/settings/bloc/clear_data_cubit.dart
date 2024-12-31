import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';

part 'clear_data_cubit.freezed.dart';
part 'clear_data_state.dart';

@injectable
class ClearDataCubit extends Cubit<ClearDataState> {
  ClearDataCubit() : super(const ClearDataState.initial());

  Future<void> clearData() async {
    emit(const ClearDataState.loading());

    await NickImageWidget.clearCache();
    await InAppWebViewController.clearAllCache();

    // CookieManager.instance().deleteAllCookies();
    await Future.delayed(Duration(milliseconds: 300));
    emit(const ClearDataState.success());
  }
}
