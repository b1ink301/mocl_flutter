import 'package:dio/dio.dart';
import 'package:mocl_shared/error/failures.dart';
import 'package:mocl_shared/parser/bobaedream/bobaedream_parser.dart';
import 'package:mocl_shared/parser/mlbpark/mlbpark_parser.dart';
import 'package:test/test.dart';

Response<Object> _response(Object data) => Response<Object>(
  data: data,
  requestOptions: RequestOptions(path: ''),
);

void main() {
  group('지워진 글은 파싱 실패가 아니라 DeletedPostFailure', () {
    test('보배드림: 삭제 안내 alert 만 온다', () async {
      final result = await const BobaedreamParser().detail(
        _response("<script>alert('삭제된 글 입니다.');history.back();</script>"),
      );
      expect(result.getLeft().toNullable(), isA<DeletedPostFailure>());
    });

    test('보배드림: 본문도 안내도 없으면 그대로 파싱 실패(고장 신고 대상)', () async {
      final result = await const BobaedreamParser().detail(
        _response('<html><body><div>점검 중</div></body></html>'),
      );
      expect(result.getLeft().toNullable(), isA<GetDetailFailure>());
    });

    test('엠팍: 본문 자리에 삭제 안내만 온다', () async {
      final result = await const MlbparkParser().detail(
        _response([
          '<html><head><meta property="og:title" content="↗ 파크에 오면 즐겁다 MLBPARK" /></head>'
              "<body><div class='message'><span>해당 글</span>이 <span>삭제</span>되었거나 "
              '<span>잘못된 유입경로</span>입니다.</div></body></html>',
          '',
        ]),
      );
      expect(result.getLeft().toNullable(), isA<DeletedPostFailure>());
    });

    test('엠팍: 본문이 있으면 그대로 읽는다', () async {
      final result = await const MlbparkParser().detail(
        _response([
          '<html><head><meta property="og:title" content="제목 : MLBPARK" /></head>'
              '<body><div class="ar_txt" id="contentDetail">본문</div></body></html>',
          '',
        ]),
      );
      expect(result.getRight().toNullable()?.bodyHtml, '본문');
    });
  });
}
