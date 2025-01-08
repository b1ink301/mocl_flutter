import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pagination_notifier_provider.freezed.dart';

part 'pagination_notifier_provider.g.dart';

part 'pagination_state.dart';

@riverpod
class CurrentMainItem extends _$CurrentMainItem {
  @override
  MainItem? build() => null;  // 초기값은 null

  void setItem(MainItem item) => state = item;
}

@riverpod
class PaginationNotifier extends _$PaginationNotifier {
  late final MainItem _mainItem;
  int _lastId = -1;
  final List<ListItem> _list = [];
  bool _isLoading = false;

  ListItem getItem(int index) => _list.elementAt(index);

  bool get isLoading => _isLoading;

  String get title => _mainItem.text;

  String get smallTitle => _mainItem.siteType.title;

  int get listCount => _list.length;

  void initialize(MainItem item) {
    _mainItem = item;
  }

  @override
  PaginationState build() {
    final page = ref.watch(_currentPageProvider);
    _fetchItems(page);
    return const PaginationState.initial();
  }

  void refresh() {
    _lastId = -1;
    _list.clear();
    ref.invalidateSelf();
    ref.invalidate(_currentPageProvider);
  }

  void fetchNextItems() {
    if (!isLoading) {
      ref.read(_currentPageProvider.notifier).nextPage();
    }
  }

  Future<void> _fetchItems(int page) async {
    if (isLoading) return;
    _isLoading = true;
    state = const PaginationState.loading();
    try {
      final params = GetListParams(
        mainItem: _mainItem,
        page: page,
        lastId: _lastId,
      );
      final result = await ref.read(getListProvider)(params);

      result.fold(
        (failure) => state = PaginationState.failed(failure.message),
        (data) {
          if (data.isNotEmpty) {
            _lastId = data.last.id;
            _list.addAll(data);
          }
          state = const PaginationState.loaded();
        },
      );
    } catch (e) {
      state = PaginationState.failed(e.toString());
    } finally {
      _isLoading = false;
    }
  }

  void updateItemReadStatus(int itemId) {
    final index = _list.indexWhere((item) => item.id == itemId);
    if (index == -1) return;
    state = const PaginationState.loading();
    _list[index] = _list[index].copyWith(isRead: true);
    state = const PaginationState.loaded();
  }

  void dispose() {
    _list.clear();
  }
}

@riverpod
class _CurrentPage extends _$CurrentPage {
  @override
  int build() {
    final siteType = ref.watch(currentSiteTypeNotifierProvider);
    return siteType == SiteType.clien ? 0 : 1;
  }

  void nextPage() => state++;

  void refresh() => ref.invalidateSelf();
}
