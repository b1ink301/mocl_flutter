import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_site_type.dart';

@singleton
class SiteTypeBloc extends Cubit<SiteType> {
  final GetSiteType _getSiteType;
  final SetSiteType _setSiteType;

  SiteTypeBloc({
    required GetSiteType getSiteType,
    required SetSiteType setSiteType,
  })  : _getSiteType = getSiteType,
        _setSiteType = setSiteType,
        super(SiteType.damoang) {
    _init();
  }

  void _init() {
    emit(_getSiteType(NoParams()));
  }

  String get title => state.title;

  void setSiteType(SiteType siteType) {
    _setSiteType(siteType);
    emit(siteType);
  }
}
