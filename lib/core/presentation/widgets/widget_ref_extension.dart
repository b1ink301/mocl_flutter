/*
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


extension WidgetRefExtension on WidgetRef {
  /// Provider 안전 읽기
  /// ① this.read → ② 실패 시 globalContainer.read
  T safeRead<T>(ProviderListenable<T> provider) {
    try {
      return read(provider); // ①
    } catch (e) {
      // ②
      try {
        final result = globalContainer.read(provider);
        MoclLogger.log('WidgetRef dispose → fallback: $e');
        return result;
      } catch (e) {
        MoclLogger.log('safeRead error: $e');
        rethrow;
      }
    }
  }

  /// BuildContext 안전 확보
  /// ① context → ② 실패 시 navigationContext
  Future<BuildContext> safeBuildContext<T>() async {
    try {
      return context; // ①
    } catch (e) {
      // ②
      try {
        final result = await navigationContext;
        logger.i('context dispose → fallback: $e');
        return result;
      } catch (e) {
        logger.e('safeBuildContext error: $e');
        rethrow;
      }
    }
  }

  /// Provider 존재 여부 확인 (fallback 포함)
  bool safeExist<T>(ProviderBase<Object?> provider) {
    try {
      return exists(provider); // ①
    } catch (e) {
      // ②
      try {
        final result = globalContainer.exists(provider);
        logger.i('exists dispose → fallback: $e');
        return result;
      } catch (e) {
        logger.e('safeExist error: $e');
        rethrow;
      }
    }
  }

  /// Provider 무효화 (fallback 포함)
  void safeInvalidate<T>(ProviderOrFamily provider) {
    try {
      invalidate(provider); // ①
    } catch (e) {
      // ②
      try {
        globalContainer.invalidate(provider);
        logger.i('invalidate dispose → fallback: $e');
      } catch (e) {
        logger.e('safeInvalidate error: $e');
        rethrow;
      }
    }
  }
}

extension NullableWidgetRef on WidgetRef? {
  /// null 가능 WidgetRef용 Provider 읽기
  /// this.read → fallback to globalContainer.read
  T safeRead<T>(ProviderListenable<T> provider) {
    try {
      if (this == null) throw Exception('WidgetRef is null');
      return this!.read(provider); // ①
    } catch (e) {
      // ②
      try {
        final result = globalContainer.read(provider);
        logger.i('null/disposed → fallback: $e');
        return result;
      } catch (e) {
        logger.e('safeRead (nullable) error: $e');
        rethrow;
      }
    }
  }

  /// null 가능 BuildContext 확보
  Future<BuildContext> safeBuildContext<T>() async {
    try {
      return this?.context ?? await navigationContext; // ①
    } catch (e) {
      // ②
      try {
        final result = await navigationContext;
        logger.i('context null/disposed → fallback: $e');
        return result;
      } catch (e) {
        logger.e('safeBuildContext (nullable) error: $e');
        rethrow;
      }
    }
  }

  /// null 가능 Provider 존재 여부 확인
  bool safeExist<T>(ProviderBase<Object?> provider) {
    try {
      if (this == null) throw Exception('WidgetRef is null');
      return this!.exists(provider); // ①
    } catch (e) {
      // ②
      try {
        final result = globalContainer.exists(provider);
        logger.i('exists null/disposed → fallback: $e');
        return result;
      } catch (e) {
        logger.e('safeExist (nullable) error: $e');
        rethrow;
      }
    }
  }
}*/
