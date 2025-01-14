import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

@riverpod
Dio dio(Ref ref) => Dio();

@riverpod
CookieJar cookieJar(Ref ref) => CookieJar();

@riverpod
ApiClient apiClient(Ref ref) {
  final Dio dio = ref.watch(dioProvider);
  final CookieJar cookieJar = ref.watch(cookieJarProvider);

  return ApiClient(dio)..init(cookieJar);
}
