import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'detail_view_model.freezed.dart';

part 'detail_view_model.g.dart';

part 'detail_view_state.dart';

@riverpod
class DetailViewModel extends _$DetailViewModel {
  late final ListItem _listItem;
  late SiteType _siteType;

  @override
  DetailViewState build() {
    _siteType = ref.watch(currentSiteTypeNotifierProvider);
    _getData();
    return DetailViewState.loading();
  }

  void initialize(ListItem listItem) {
    _listItem = listItem;
  }

  String get itemUrl => _siteType == SiteType.naverCafe
      ? 'https://m.cafe.naver.com/ca-fe/web/cafes/${_listItem.board}/articles/${_listItem.id}'
      : _listItem.url;

  String get smallTitle => '${_siteType.title} > ${_listItem.boardTitle}';

  String get title => _listItem.title;

  Future<void> _getData() async {
    final getDetail = ref.read(getDetailProvider);
    final result = await getDetail(_listItem);
    result.fold((failure) {
      state = DetailFailed(failure.message);
    }, (data) {
      _markAsRead();
      state = DetailSuccess(data);
    });
  }

  void refresh() => ref.invalidateSelf();

  Future<bool> openBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    return await launchUrl(uri);
  }

  Future<void> _markAsRead() async {
    if (!_listItem.isRead) {
      final params =
          SetReadFlagParams(siteType: _siteType, boardId: _listItem.id);
      final setReadFlag = ref.read(setReadProvider);
      await setReadFlag(params);
      ref.read(readableStateNotifierProvider.notifier).update(_listItem.id);
    }
  }
}
