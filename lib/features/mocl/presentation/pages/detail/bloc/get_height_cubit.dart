import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'get_height_cubit.freezed.dart';

part 'get_height_state.dart';

@injectable
class GetHeightCubit extends Cubit<GetHeightState> {
  GetHeightCubit() : super(const _Initial());

  void getHeight(
    String text,
    TextStyle style,
    double width,
  ) {
    final height = _calculateTitleHeight(text, style, width);
    emit(_Success(height));
  }

  double _calculateTitleHeight(
    String text,
    TextStyle style,
    double width,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width - (48 + 16 * 3));

    final titleHeight = textPainter.height;
    return max(30, titleHeight) + 36; // 텍스트 높이 반환
  }
}
