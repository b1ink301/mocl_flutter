import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/settings/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/settings/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/bloc/site_type_bloc.dart';

part 'main_data_bloc.freezed.dart';
part 'main_data_event.dart';
part 'main_data_state.dart';

@lazySingleton
class MainDataBloc extends Bloc<MainDataEvent, MainDataState> {
  final GetMainList getMainList;
  final SetMainList setMainList;
  final GetSiteType getSiteType;
  final SetSiteType setSiteType;

  late final StreamSubscription<SiteType>? _siteTypeSubscription;

  MainDataBloc({
    required this.getMainList,
    required this.setMainList,
    required this.getSiteType,
    required this.setSiteType,
  }) : super(const StateInitial()) {
    on<GetListEvent>(_onGetListEvent);
  }

  void testInitialize() {
    _siteTypeSubscription = null;
  }

  void initialize(SiteTypeBloc siteTypeBloc) {
    _siteTypeSubscription = siteTypeBloc.stream.listen((siteType) {
      add(MainDataEvent.getList(siteType: siteType));
    });

    // 초기 데이터 로드
    add(MainDataEvent.getList(siteType: siteTypeBloc.state));
  }

  Future<void> _onGetListEvent(
    GetListEvent event,
    Emitter<MainDataState> emit,
  ) async {
    emit(const StateLoading());

    final Result<List<MainItem>> result = await getMainList.call(
      event.siteType,
    );
    switch (result) {
      case ResultLoading<List<MainItem>>():
        break;
      case ResultSuccess<List<MainItem>>():
        emit(StateSuccess(result.data));
        break;
      case ResultFailure<List<MainItem>>():
        emit(StateFailure(result.failure.message));
        break;
    }
  }

  void refresh(SiteType siteType) => add(GetListEvent(siteType: siteType));

  Future<void> addMainList({
    required SiteType siteType,
    required List<MainItem> list,
  }) async {
    final params = SetMainParams(siteType: siteType, list: list);
    await setMainList(params);
    refresh(siteType);
  }

  @override
  Future<void> close() {
    _siteTypeSubscription?.cancel();
    return super.close();
  }
}
