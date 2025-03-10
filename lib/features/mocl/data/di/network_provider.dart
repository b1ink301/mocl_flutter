import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasources/remote/base/base_api.dart';
import '../datasources/remote/clien/clien_api.dart';
import '../datasources/remote/damoang/damoang_api.dart';
import '../datasources/remote/meeco/meeco_api.dart';
import '../datasources/remote/navercafe/naver_cafe_api.dart';
import '../datasources/remote/reddit/reddit_api.dart';
import '../datasources/remote/theqoo/theqoo_api.dart';

part 'network_provider.g.dart';

@riverpod
Dio dio(Ref ref) => Dio();

@riverpod
CookieJar cookieJar(Ref ref) => CookieJar();

@riverpod
BaseApi theQooApiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final CookieJar cookieJar = ref.watch(cookieJarProvider);
  return TheQooApi(dio, userAgentMobile)..init(cookieJar);
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
BaseApi meecoApiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final CookieJar cookieJar = ref.watch(cookieJarProvider);
  return MeecoApi(dio, userAgentMobile)..init(cookieJar);
}
