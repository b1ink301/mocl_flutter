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
import 'package:mocl_flutter/features/remote_config/application/remote_config_providers.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../html_parser/data/datasources/clien/clien_api.dart';

part 'network_provider.g.dart';

/// [site] 요청 UA. 기본은 사이트마다 정한 [preset] 이고, 원격 설정이 있으면 따른다.
String _userAgent(Ref ref, SiteType site, UserAgentPreset preset) => ref
    .watch(remoteConfigProvider)
    .userAgentFor(site, defaultPreset: preset, builtIn: builtInUserAgents);

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
  final String ua = _userAgent(ref, SiteType.theqoo, UserAgentPreset.mobile);
  return TheQooApi(_buildDio(ua), ua);
}

@riverpod
BaseApi ruliwebApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.ruliweb, UserAgentPreset.mobile);
  return RuliwebApi(_buildDio(ua), ua);
}

@riverpod
BaseApi ppomppuApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.ppomppu, UserAgentPreset.mobile);
  return PpomppuApi(_buildDio(ua), ua);
}

@riverpod
BaseApi invenApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.inven, UserAgentPreset.mobile);
  return InvenApi(_buildDio(ua), ua);
}

@riverpod
BaseApi bobaedreamApiClient(Ref ref) {
  final String ua = _userAgent(
    ref,
    SiteType.bobaedream,
    UserAgentPreset.mobile,
  );
  return BobaedreamApi(_buildDio(ua), ua);
}

@riverpod
BaseApi cook82ApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.cook82, UserAgentPreset.mobile);
  return Cook82Api(_buildDio(ua), ua);
}

@riverpod
BaseApi dcinsideApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.dcinside, UserAgentPreset.mobile);
  return DcinsideApi(_buildDio(ua), ua);
}

@riverpod
BaseApi dogdripApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.dogdrip, UserAgentPreset.mobile);
  return DogdripApi(_buildDio(ua), ua);
}

@riverpod
BaseApi mlbparkApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.mlbpark, UserAgentPreset.mobile);
  return MlbparkApi(_buildDio(ua), ua);
}

@riverpod
BaseApi instizApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.instiz, UserAgentPreset.mobile);
  return InstizApi(_buildDio(ua), ua);
}

@riverpod
BaseApi nateApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.nate, UserAgentPreset.mobile);
  return NateApi(_buildDio(ua), ua);
}

@riverpod
BaseApi arcaliveApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.arcalive, UserAgentPreset.mobile);
  return ArcaliveApi(_buildDio(ua), ua)..init(CookieJar());
}

@riverpod
BaseApi clienApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.clien, UserAgentPreset.pc);
  return ClienApi(_buildDio(ua), ua)..init(CookieJar());
}

@riverpod
BaseApi damoangApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.damoang, UserAgentPreset.pc);
  return DamoangApi(_buildDio(ua), ua)..init(CookieJar());
}

@riverpod
BaseApi naverCafeApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.naverCafe, UserAgentPreset.mobile);
  return NaverCafeApi(_buildDio(ua), ua)..init(CookieJar());
}

@riverpod
BaseApi redditApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.reddit, UserAgentPreset.pc);
  return RedditApi(_buildDio(ua), ua)..init(CookieJar());
}

@riverpod
BaseApi geekNewsApiClient(Ref ref) {
  // 긱뉴스 CloudFront 는 Mac PC Chrome UA 중 흔한 스크래퍼 값(Chrome/120 · 140 ·
  // 150.0.0.0)을 정확히 맞춰 403 으로 막는다. 모바일 UA 도 같은 HTML 을 준다.
  final String ua = _userAgent(ref, SiteType.geekNews, UserAgentPreset.mobile);
  return GeekNewsApi(_buildDio(ua), ua);
}

@riverpod
BaseApi meecoApiClient(Ref ref) {
  final String ua = _userAgent(ref, SiteType.meeco, UserAgentPreset.mobile);
  return MeecoApi(_buildDio(ua), ua)..init(CookieJar());
}
