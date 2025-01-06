import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.g.dart';

final localeCodeProvider = StateProvider<String>((ref) => 'ko');

@riverpod
class CurrentSiteType extends _$CurrentSiteType {
  @override
  SiteType build() {
    final getSiteType = ref.watch(getSiteTypeProvider);
    return getSiteType(NoParams());
  }

  void changeSiteType(SiteType newSiteType) {
    if (state != newSiteType) {
      final setSiteType = ref.read(setSiteTypeProvider);
      setSiteType(newSiteType);
      state = newSiteType;
    }
  }
}

const double kMoreIconSize = 48.0; // more 아이콘의 크기
const double kHorizontalPadding = 16.0; // 좌우 패딩
const double kMinTextHeight = 30.0; // 최소 텍스트 높이
const double kExtraVerticalSpace = 36.0; // 추가 수직 공간

@riverpod
double appbarHeight(
  ref,
  String text,
  TextStyle style,
  double screenWidth,
) {
  final availableWidth = screenWidth -
      kMoreIconSize // more 아이콘 크기
      -
      (kHorizontalPadding * 2); // 좌우 패딩

  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    maxLines: 3,
    textDirection: TextDirection.ltr,
  )..layout(
      minWidth: 0,
      maxWidth: availableWidth,
    );

  // 최소 높이와 비교하여 더 큰 값 반환
  return max(kMinTextHeight, textPainter.height) + kExtraVerticalSpace;
}

@riverpod
class ReadableState extends _$ReadableState {
  @override
  int build() {
    return -1;
  }

  void update(int newId) {
    if (state != newId) {
      state = newId;
    }
  }
}

@riverpod
Future<Either<Failure, String>> getAppVersion(ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    final version = 'v${info.version}-${info.buildNumber}';
    return Right(version);
  } catch (e) {
    return Left(GetVersionFailure(message: e.toString()));
  }
}


@riverpod
Future<void> clearData(ref) async {
  await NickImageWidget.clearCache();
  await InAppWebViewController.clearAllCache();

  // CookieManager.instance().deleteAllCookies();
  await Future.delayed(Duration(milliseconds: 300));
}