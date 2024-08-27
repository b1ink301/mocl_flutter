import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';

class MainDlgViewModel extends BaseViewModel {
  final GetMainListFromJson _getMainListFromJson;
  final GetSiteType _getSiteType;

  late final SiteType _siteType;

  final List<MainItem> _selectedItems = [];

  MainDlgViewModel({
    required GetMainListFromJson getMainListFromJson,
    required GetSiteType getSiteType,
  })  : _getMainListFromJson = getMainListFromJson,
        _getSiteType = getSiteType {
    _siteType = _getSiteType(NoParams());
    getList();
  }

  AsyncValue<List<MainItem>> _data = const AsyncValue.loading();

  AsyncValue<List<MainItem>> get data => _data;

  Future<void> getList() async {
    _data = const AsyncValue.loading();
    notifyListeners();

    try {
      final result = await _getMainListFromJson(_siteType);
      if (result is ResultSuccess<List<MainItem>>) {
        _init(result.data);
        _data = AsyncValue.data(result.data);
      } else if (result is ResultFailure) {
        _data = AsyncValue.error(result, StackTrace.current);
      }
    } catch (error, stackTrace) {
      _data = AsyncValue.error(error, stackTrace);
    }

    notifyListeners();
  }

  bool hasItem<T>(T? item) {
    if (item != null && item is MainItem) {
      return _selectedItems.contains(item);
    } else {
      return false;
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

  void pop(BuildContext context) => context.pop(_selectedItems);
}
