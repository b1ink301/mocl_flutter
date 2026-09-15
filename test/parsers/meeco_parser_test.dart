import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/meeco/meeco_parser.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  setUpAll(() {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  });

  group('MeecoParser detail', () {
    late String fixture;

    setUpAll(() {
      fixture = File('test/fixtures/meeco_detail.html').readAsStringSync();
    });

    test('스티커(span.meeco-sticker)를 img 로 바꾼다', () async {
      const parser = MeecoParser(false);

      final result = await parser.detail(
        Response(data: fixture, requestOptions: RequestOptions(path: '')),
      );
      final details = result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details,
      );

      final sticker = details.comments.first.bodyHtml;
      // CSS 배경으로만 있던 스티커가 실제 이미지 태그가 되어야 한다.
      expect(sticker, isNot(contains('meeco-sticker')));
      expect(
        sticker,
        contains(
          '<img src="https://img.meeco.kr/files/attach/images/139/691/012/030'
          '/81f2dab7d8192f7760202c525f67bae7.jpg"',
        ),
      );
      // background-size:contain 처럼 상자를 넘지 않도록 상한만 준다.
      expect(sticker, contains('max-width:100px'));
      expect(sticker, contains('max-height:100px'));
    });

    test('2자리 연도 댓글 시각을 2000년대로 읽는다', () async {
      const parser = MeecoParser(false);

      final result = await parser.detail(
        Response(data: fixture, requestOptions: RequestOptions(path: '')),
      );
      final details = result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details,
      );

      // `26.09.13. 09:34` 를 서기 26년으로 읽으면 "2001년 전" 이 된다.
      expect(details.comments.first.info, isNot(contains('년 전')));
    });
  });
}
