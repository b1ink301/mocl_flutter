import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/detail_page/application/repository_provider.dart';
import 'package:mocl_flutter/features/detail_page/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/features/detail_page/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/detail_page/domain/usecases/write_comment.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_provider.g.dart';

@riverpod
GetDetail getDetail(Ref ref, SiteType siteType) {
  final repository = ref.watch(detailRepositoryProvider(siteType));
  return GetDetail(detailRepository: repository);
}

@riverpod
SetReadFlag setReadFlag(Ref ref, SiteType siteType) {
  final repository = ref.watch(detailRepositoryProvider(siteType));
  return SetReadFlag(detailRepository: repository);
}

@riverpod
WriteComment writeComment(Ref ref, SiteType siteType) {
  final repository = ref.watch(detailRepositoryProvider(siteType));
  return WriteComment(detailRepository: repository);
}

/// 이 사이트에서 앱으로 댓글을 쓸 수 있는지.
///
/// 저장소까지 만들면 로컬 DB 를 끌어오므로 API 객체에서 바로 읽는다.
@riverpod
bool supportsCommentWrite(Ref ref, SiteType siteType) =>
    ref.watch(currentParserProvider(siteType)).$2.supportsCommentWrite;
