import 'dart:collection';

import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/bloc/main_data_json_bloc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_list_dlg_view_model.g.dart';

@riverpod
class AddListDlgViewModel extends _$AddListDlgViewModel {
  late final SiteType _siteType;
  final List<MainItem> _selectedItems = [];

  List<MainItem> get selectedItems => UnmodifiableListView(_selectedItems);

  @override
  FutureOr<List<MainItem>> build() {
    _siteType = ref.watch(currentSiteTypeProvider);
    _reqFetch();
    return AsyncLoading();
  }

  Future<void> _reqFetch() async {
    state = const AsyncLoading();

    final getMainListFromJson = ref.read(getMainListFromJsonProvider);
    final result = await getMainListFromJson(_siteType);
    result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (data) {
        _init(data);
        state = AsyncData(data);
      },
    );
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
  }

  bool hasItem(MainItem item) => _selectedItems.contains(item);
}
