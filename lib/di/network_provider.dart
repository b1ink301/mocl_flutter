import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/clien/data/datasources/remote/api/clien_api.dart';
import 'package:mocl_flutter/features/damoang/data/datasources/remote/api/damoang_api.dart';
import 'package:mocl_flutter/features/meeco/data/datasources/remote/api/meeco_api.dart';
import 'package:mocl_flutter/features/naver_cafe/data/datasources/remote/api/naver_cafe_api.dart';
import 'package:mocl_flutter/features/reddit/data/datasources/remote/api/reddit_api.dart';
import 'package:mocl_flutter/features/theqoo/data/datasources/remote/api/theqoo_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
