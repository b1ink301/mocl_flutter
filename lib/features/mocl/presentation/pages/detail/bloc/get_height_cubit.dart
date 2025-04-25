import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'get_height_cubit.freezed.dart';

part 'get_height_state.dart';

@injectable
class GetHeightCubit extends Cubit<GetHeightState> {
  static const double kMoreIconSize = 48.0; // more 아이콘의 크기
  static const double kHorizontalPadding = 16.0; // 좌우 패딩
  static const double kMinTextHeight = 30.0; // 최소 텍스트 높이
  static const double kExtraVerticalSpace = 36.0; // 추가 수직 공간

  GetHeightCubit() : super(const InitialGetHeightState());

  void getHeight(
    String text,
    TextStyle style,
    double screenWidth,
  ) {
    final height = _calculateTitleHeight(text, style, screenWidth);
    emit(SuccessGetHeightState(height));
  }

  double _calculateTitleHeight(
    String text,
    TextStyle style,
    double screenWidth,
  ) {
    final double availableWidth =
        screenWidth - kMoreIconSize - (kHorizontalPadding * 2);

    final TextPainter textPainter = TextPainter(
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
}
