import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';

part 'detail_view_bloc.freezed.dart';
part 'detail_view_event.dart';
part 'detail_view_state.dart';

@injectable
class DetailViewBloc extends Bloc<DetailViewEvent, DetailViewState> {
  final GetDetail _getDetail;
  final SetReadFlag _setReadFlag;
  final ListItem _listItem;
  final SiteType _siteType;

  DetailViewBloc(
    this._getDetail,
    this._setReadFlag,
    @factoryParam this._listItem,
    @factoryParam this._siteType,
  ) : super(const DetailLoading()) {
    on<DetailsEvent>(_onDetailsEvent);
  }

  String get smallTitle => '${_siteType.title} > ${_listItem.boardTitle}';

  String get title => _listItem.title;

  String get itemUrl => _siteType == SiteType.naverCafe
      ? 'https://m.cafe.naver.com/ca-fe/web/cafes/${_listItem.board}/articles/${_listItem.id}'
      : _listItem.url;

  void refresh() => add(const DetailsEvent());

  Future<void> _onDetailsEvent(
    DetailsEvent event,
    Emitter<DetailViewState> emit,
  ) async {
    try {
      emit(const DetailLoading());
      final Result result = await _getDetail(_listItem);
      result.whenOrNull(
        success: (data) {
          _markAsRead();
          emit(DetailSuccess(data));
        },
        failure: (failure) {
          emit(DetailFailed(failure.message));
        },
      );
    } catch (e) {
      emit(DetailFailed(e.toString()));
    }
  }

  void _markAsRead() async {
    if (!_listItem.isRead) {
      // _listItem.markAsRead();
      final params =
          SetReadFlagParams(siteType: _siteType, boardId: _listItem.id);
      await _setReadFlag(params);
    }
  }
}
