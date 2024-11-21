import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/site_type_bloc.dart';

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
    on<SetSiteTypeEvent>(_onSetSiteTypeEvent);
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

  Future<void> _onSetSiteTypeEvent(
    SetSiteTypeEvent event,
    Emitter<MainDataState> emit,
  ) async {}

  Future<void> _onGetListEvent(
    GetListEvent event,
    Emitter<MainDataState> emit,
  ) async {
    emit(const StateLoading());

    final result = await getMainList.call(event.siteType);
    result.whenOrNull(
      success: (data) {
          // emit(StateSuccess(data.whereType<MainItem>().toList()));
        if (data is List<MainItem>) {
          emit(StateSuccess(data));
        } else {
          emit(StateFailure('Unexpected data type: ${data.runtimeType}'));
        }
      },
      failure: (failure) {
        if (failure is NotLoginFailure) {
          emit(StateRequireLogin(failure.message));
        } else {
          emit(StateFailure(failure.message));
        }
      },
    );
  }

  void refresh(SiteType siteType) {
    add(GetListEvent(siteType: siteType));
  }

  Future<void> setMainListWithParams(SetMainParams params) async {
    await setMainList(params);
    refresh(params.siteType);
  }

  @override
  Future<void> close() {
    _siteTypeSubscription?.cancel();
    return super.close();
  }
}
