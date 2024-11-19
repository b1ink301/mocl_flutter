import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';

part 'main_data_json_event.dart';
part 'main_data_json_state.dart';
part 'main_data_json_bloc.freezed.dart';

@injectable
class MainDataJsonBloc extends Bloc<MainDataJsonEvent, MainDataJsonState> {
  late final GetMainListFromJson getMainListFromJson;
  late final SetMainList setMainList;

  final List<MainItem> _selectedItems = [];
  List<MainItem> get selectedItems => _selectedItems;

  MainDataJsonBloc({
    required this.getMainListFromJson,
    required this.setMainList,
  }) : super(const MainDataJsonState.initial()) {
    on<GetListEvent>(_onGetListEvent);
  }

  Future<void> _onGetListEvent(
    GetListEvent event,
    Emitter<MainDataJsonState> emit,
  ) async {
    log('[MainDataJsonBloc] event=$event');
    emit(const MainDataJsonState.loading());
    var result = await getMainListFromJson.call(event.siteType);
    if (result is ResultSuccess) {
      _init(result.data);
      emit(MainDataJsonState.success(result.data));
    } else if (result is ResultFailure) {
      emit(const MainDataJsonState.failure("failure"));
    }
  }

  void onChanged<T>(bool isChecked, T? item) {
    if (item != null && item is MainItem) {
      if (isChecked) {
        _addItem(item);
      } else {
        _removeItem(item);
      }
    }
  }

  void _clear() => _selectedItems.clear();

  void _addAll(List<MainItem> list) {
    final items = list.where((item) => item.hasItem);
    _selectedItems.addAll(items);
  }

  void _addItem(MainItem item) {
    if (!_selectedItems.contains(item)) {
      _selectedItems.add(item);
    }
  }

  void _removeItem(MainItem item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    }
  }

  void _init(List<MainItem> data) {
    _clear();
    _addAll(data);
    log('MainDlgViewModel List=$_selectedItems');
  }

  bool hasItem(MainItem item) => _selectedItems.contains(item);
}
