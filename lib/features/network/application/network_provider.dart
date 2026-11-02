import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/arcalive/arcalive_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/bobaedream/bobaedream_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/cook82/cook82_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/dogdrip/dogdrip_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/instiz/instiz_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/mlbpark/mlbpark_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/nate/nate_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/dcinside/dcinside_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/damoang/damoang_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/geek_news/geek_news_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/inven/inven_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/meeco/meeco_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/naver_cafe/naver_cafe_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/ppomppu/ppomppu_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/reddit/reddit_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/ruliweb/ruliweb_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/theqoo/theqoo_api.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../html_parser/data/datasources/clien/clien_api.dart';

part 'network_provider.g.dart';

/// 백그라운드 → 포그라운드 복귀 후 소켓이 죽어 요청이 영영 끝나지 않는 문제 방지.
/// 모든 Dio 인스턴스가 동일한 timeout 정책을 갖도록 일원화.
///
/// [userAgent] 는 요청 헤더가 아니라 HttpClient 에 박는다. dart:io 는 리다이렉트를
/// 따라갈 때 새 요청을 HttpClient 기본 UA(`Dart/x.y (dart:io)`)로 만들고 원래
/// 요청의 User-Agent 헤더를 넘기지 않아, Dart UA 를 막는 사이트(클리앙 등)에서
/// 리다이렉트 끝이 403 이 된다. 사이트마다 UA 가 달라 Dio 는 사이트별로 따로 둔다.
Dio _buildDio(String userAgent) =>
    Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      )
      ..httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () => HttpClient()..userAgent = userAgent,
      );

@riverpod
BaseApi theQooApiClient(Ref ref) {
  return TheQooApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi ruliwebApiClient(Ref ref) {
  return RuliwebApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi ppomppuApiClient(Ref ref) {
  return PpomppuApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi invenApiClient(Ref ref) {
  return InvenApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi bobaedreamApiClient(Ref ref) {
  return BobaedreamApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi cook82ApiClient(Ref ref) {
  return Cook82Api(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi dcinsideApiClient(Ref ref) {
  return DcinsideApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi dogdripApiClient(Ref ref) {
  return DogdripApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi mlbparkApiClient(Ref ref) {
  return MlbparkApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi instizApiClient(Ref ref) {
  return InstizApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi nateApiClient(Ref ref) {
  return NateApi(_buildDio(userAgentMobile), userAgentMobile);
}

@riverpod
BaseApi arcaliveApiClient(Ref ref) {
  return ArcaliveApi(_buildDio(userAgentMobile), userAgentMobile)
    ..init(CookieJar());
}

@riverpod
BaseApi clienApiClient(Ref ref) {
  return ClienApi(_buildDio(userAgentPc), userAgentPc)..init(CookieJar());
}

@riverpod
BaseApi damoangApiClient(Ref ref) {
  return DamoangApi(_buildDio(userAgentPc), userAgentPc)..init(CookieJar());
}

@riverpod
BaseApi naverCafeApiClient(Ref ref) {
  return NaverCafeApi(_buildDio(userAgentMobile), userAgentMobile)
    ..init(CookieJar());
}

@riverpod
BaseApi redditApiClient(Ref ref) {
  return RedditApi(_buildDio(userAgentPc), userAgentPc)..init(CookieJar());
}

@riverpod
BaseApi geekNewsApiClient(Ref ref) {
  return GeekNewsApi(_buildDio(userAgentPc), userAgentPc);
}

@riverpod
BaseApi meecoApiClient(Ref ref) {
  return MeecoApi(_buildDio(userAgentMobile), userAgentMobile)
    ..init(CookieJar());
}
