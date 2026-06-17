import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';

import '../../../../config/mocl_text_styles.dart';
import '../../../../core/application/app_provider.dart';
import '../../../html_parser/application/datasource_provider.dart';
import '../../application/detail_providers.dart';

mixin class DetailState {
  AppTextStyles appTextStyles(WidgetRef ref) => ref.watch(appTextStylesFontSizeProvider);

  AsyncValue<Details> detailState(WidgetRef ref) => ref.watch(detailsProvider);

  /// 본문/댓글 이미지 로드 시 보낼 Referer = 현재 사이트의 baseUrl.
  /// (디시 등 일부 CDN 은 Referer 가 사이트 도메인이어야 이미지를 준다.)
  /// presentation 위젯이 application provider 를 직접 참조하지 않도록 여기서 노출.
  String imageRefererState(WidgetRef ref) {
    final siteType = ref.watch(currentSiteTypeProvider);
    final (parser, _) = ref.watch(currentParserProvider(siteType));
    return parser.baseUrl;
  }

  String titleState(WidgetRef ref) => ref.watch(detailTitleStateProvider);

  String smallTitleState(WidgetRef ref) => ref.watch(detailSmallTitleProvider);

  double appbarHeight(WidgetRef ref, String title) =>
      ref.watch(detailAppbarHeightProvider(title));
}
