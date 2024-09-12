import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_site_type.dart';

part 'main_data_bloc.freezed.dart';
part 'main_data_event.dart';
part 'main_data_state.dart';

@lazySingleton
class MainDataBloc extends Bloc<MainDataEvent, MainDataState> {
  final GetMainList getMainList;
  final SetMainList setMainList;
  final GetSiteType getSiteType;
  final SetSiteType setSiteType;

  MainDataBloc({
    required this.getMainList,
    required this.setMainList,
    required this.getSiteType,
    required this.setSiteType,
  }) : super(const MainDataState.initial()) {
    on<GetListEvent>(_onGetListEvent);
    on<SetSiteTypeEvent>(_onSetSiteTypeEvent);
  }

  Future<void> _onSetSiteTypeEvent(
    SetSiteTypeEvent event,
    Emitter<MainDataState> emit,
  ) async {}

  Future<void> _onGetListEvent(
    GetListEvent event,
    Emitter<MainDataState> emit,
  ) async {
    log('MainDataBloc event=$event');
    emit(const MainDataState.loading());
    var result = await getMainList.call(event.siteType);
    if (result is ResultSuccess) {
      emit(MainDataState.success(result.data));
    } else if (result is ResultFailure) {
      emit(const MainDataState.failure("failure"));
    }
  }

  void refresh(SiteType siteType) {
    add(GetListEvent(siteType: siteType));
  }

  Future<void> setMainListWithParams(SetMainParams params) async {
    await setMainList(params);
    refresh(params.siteType);
  }
}
