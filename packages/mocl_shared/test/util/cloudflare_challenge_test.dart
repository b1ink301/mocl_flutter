import 'dart:io';

import 'package:mocl_shared/util/cloudflare_challenge.dart';
import 'package:test/test.dart';

void main() {
  final String challenge = File(
    'test/fixtures/theqoo_challenge.html',
  ).readAsStringSync();

  test('cf-mitigated 헤더가 있으면 검사다', () {
    expect(
      CloudflareChallenge.isChallenge(
        status: 403,
        headers: {
          'cf-mitigated': ['challenge'],
        },
      ),
      isTrue,
    );
  });

  test('헤더 없이도 403 + 검사 페이지면 검사다(더쿠 실제 페이지)', () {
    expect(
      CloudflareChallenge.isChallenge(status: 403, body: challenge),
      isTrue,
    );
  });

  test('200 이면 본문에 표시가 있어도 검사가 아니다', () {
    expect(
      CloudflareChallenge.isChallenge(status: 200, body: challenge),
      isFalse,
    );
  });

  test('일반 403 은 검사가 아니다', () {
    expect(
      CloudflareChallenge.isChallenge(
        status: 403,
        body: '<html><body>Forbidden</body></html>',
      ),
      isFalse,
    );
  });

  test('JSON 본문(Map)은 검사가 아니다', () {
    expect(
      CloudflareChallenge.isChallenge(status: 403, body: {'error': 403}),
      isFalse,
    );
  });
}
