import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/damoang/damoang_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/geek_news/geek_news_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/meeco/meeco_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/naver_cafe/naver_cafe_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/reddit/reddit_api.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/theqoo/theqoo_api.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../html_parser/data/datasources/clien/clien_api.dart';

part 'network_provider.g.dart';

/// 백그라운드 → 포그라운드 복귀 후 소켓이 죽어 요청이 영영 끝나지 않는 문제 방지.
/// 모든 Dio 인스턴스가 동일한 timeout 정책을 갖도록 일원화.
Dio _buildDio() => Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
  ),
);

@riverpod
Dio dio(Ref ref) => _buildDio();

@riverpod
CookieJar cookieJar(Ref ref) => CookieJar();

@riverpod
BaseApi theQooApiClient(Ref ref) {
  return TheQooApi(_buildDio(), userAgentMobile);
}

@riverpod
BaseApi clienApiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final CookieJar cookieJar = ref.watch(cookieJarProvider);
  return ClienApi(dio, userAgentPc)..init(cookieJar);
}

@riverpod
BaseApi damoangApiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final CookieJar cookieJar = ref.watch(cookieJarProvider);
  return DamoangApi(dio, userAgentPc)..init(cookieJar);
}

@riverpod
BaseApi naverCafeApiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final CookieJar cookieJar = ref.watch(cookieJarProvider);
  return NaverCafeApi(dio, userAgentMobile)..init(cookieJar);
}

@riverpod
BaseApi redditApiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final CookieJar cookieJar = ref.watch(cookieJarProvider);
  return RedditApi(dio, userAgentPc)..init(cookieJar);
}

@riverpod
BaseApi geekNewsApiClient(Ref ref) {
  return GeekNewsApi(_buildDio(), userAgentPc);
}

@riverpod
BaseApi meecoApiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final CookieJar cookieJar = ref.watch(cookieJarProvider);
  return MeecoApi(dio, userAgentMobile)..init(cookieJar);
}
