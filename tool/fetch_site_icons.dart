// 사이트 대표 아이콘(파비콘)을 내려받아 `assets/icons/{site}.png` 로 정규화한다.
//
// 실행:
//   fvm dart run tool/fetch_site_icons.dart
//
// 왜 런타임에 받지 않고 에셋으로 굽는가:
//  - 사이트 절반이 `.ico` 만 주는데 Flutter 는 ICO 를 디코딩하지 못한다.
//  - `/favicon.ico` 가 HTML 을 돌려주는 곳도 있어(아카라이브·개드립·미코·더쿠)
//    사이트마다 실제 아이콘 주소를 사람이 한 번 확인해 주는 편이 확실하다.
//  - 외부 파비콘 프록시(구글 등)를 쓰면 사용자가 어떤 커뮤니티를 보는지
//    그 업체에 흘러간다. 커뮤니티 리더에서 치를 값이 아니다.
//  - 구워 두면 오프라인에서도 첫 프레임부터 바로 뜬다.
//
// 로고가 바뀌면 아래 표의 주소만 고치고 다시 실행하면 된다.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// 최종 에셋 한 변의 길이(px).
///
/// 레일 아이콘이 26dp 이므로 3배 화면에서 78px 이 필요하다. 96px 이면 그보다
/// 여유가 있고, 게시판 목록의 36dp 아이콘도 함께 감당한다.
const int _outputSize = 96;

/// 이보다 작은 원본은 확대하면 뭉개져 배지(사이트 이름 두 글자)가 낫다.
/// 통과하지 못한 사이트는 에셋을 만들지 않고, 앱에서 자동으로 배지로 넘어간다.
const int _minSourceSize = 32;

const String _outputDir = 'assets/icons';

/// 사이트별 아이콘 원본 주소.
///
/// `/favicon.ico` 대신 각 사이트가 `<link rel="apple-touch-icon">` 등으로
/// 내놓는 가장 큰 판을 골랐다(주석은 실제로 받아 본 원본 크기).
const Map<String, String> _sources = <String, String>{
  'arcalive': 'https://arca.live/static/apple-icon.png', // 192
  'bobaedream': 'https://www.bobaedream.co.kr/favicon.ico', // 48
  'clien': 'https://www.clien.net/service/image/favicon.ico', // 32
  'cook82': 'https://www.82cook.com/icon.png', // 72
  'damoang': 'https://damoang.net/favicon.ico', // 48
  'dcinside': 'https://www.dcinside.com/favicon.ico', // 32
  'dogdrip': 'https://www.dogdrip.net/files/attach/xeicon/mobicon.png', // 114
  'geekNews': 'https://news.hada.io/favicon.ico', // 32
  'instiz': 'https://static.instiz.net/m/images/ico_apple_kor.png', // 512
  'inven': 'https://static.inven.co.kr/image_2011/favicon_192x192.png', // 192
  'meeco': 'https://meeco.kr/files/attach/xeicon/mobicon.png', // 380
  'mlbpark': 'https://mlbpark.donga.com/favicon.ico', // 32
  'nate': 'https://pann.nate.com/favicon.ico', // 64
  'naverCafe': 'https://cafe.naver.com/favicon.ico', // 32
  // 뽐뿌는 16×15 GIF 뿐이라 _minSourceSize 에 걸려 걸러진다(배지 유지).
  'ppomppu': 'https://www.ppomppu.co.kr/favicon.ico',
  'reddit': 'https://www.reddit.com/favicon.ico', // 32
  'ruliweb':
      'https://img.ruliweb.com/img/2016/icon/ruliweb_icon_144_144.png', // 144
  'theqoo': 'https://theqoo.net/files/attach/xeicon/favicon.ico', // 32
};

Future<void> main() async {
  final Directory outputDir = Directory(_outputDir);
  await outputDir.create(recursive: true);

  final HttpClient client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 15)
    ..userAgent =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120.0 Safari/537.36';

  final List<String> skipped = <String>[];
  int written = 0;

  try {
    for (final MapEntry<String, String> entry in _sources.entries) {
      final String site = entry.key;
      try {
        final Uint8List bytes = await _download(client, entry.value);
        final img.Image? decoded = _decode(bytes);
        if (decoded == null) {
          skipped.add('$site — 디코딩 실패(HTML 이나 지원하지 않는 형식)');
          continue;
        }

        // 짧은 변이 기준에 못 미치면 확대해서 쓰기보다 배지로 넘긴다.
        final int shortSide = decoded.width < decoded.height
            ? decoded.width
            : decoded.height;
        if (shortSide < _minSourceSize) {
          skipped.add('$site — 원본이 ${decoded.width}×${decoded.height} 로 너무 작다');
          continue;
        }

        final img.Image square = _squared(decoded);
        final img.Image resized = img.copyResize(
          square,
          width: _outputSize,
          height: _outputSize,
          interpolation: img.Interpolation.cubic,
        );

        final File out = File('$_outputDir/$site.png');
        await out.writeAsBytes(img.encodePng(resized, level: 9));
        written++;
        stdout.writeln(
          '  $site  ${decoded.width}×${decoded.height} → $_outputSize×$_outputSize'
          '  (${(await out.length() / 1024).toStringAsFixed(1)}KB)',
        );
      } on Object catch (error) {
        skipped.add('$site — $error');
      }
    }
  } finally {
    client.close(force: true);
  }

  stdout.writeln('\n아이콘 $written개 생성 → $_outputDir/');
  if (skipped.isNotEmpty) {
    stdout.writeln('\n건너뜀(앱에서 사이트 이름 배지로 표시된다):');
    for (final String reason in skipped) {
      stdout.writeln('  - $reason');
    }
  }
}

/// 받아온 바이트를 이미지로 푼다.
///
/// ICO 는 한 파일에 16·32·48px 판이 함께 들어 있고 기본 디코더는 **첫** 판을
/// 준다. 첫 판이 16px 인 파일이 흔해(MLBPARK 등) 그대로 두면 쓸 만한 32px 판을
/// 놓치므로, ICO 는 가장 큰 판을 직접 골라 온다.
img.Image? _decode(Uint8List bytes) {
  final img.IcoDecoder ico = img.IcoDecoder();
  if (ico.isValidFile(bytes)) {
    return ico.decodeImageLargest(bytes) ?? img.decodeImage(bytes);
  }
  return img.decodeImage(bytes);
}

/// 리다이렉트를 따라가며 본문을 받아온다.
Future<Uint8List> _download(HttpClient client, String url) async {
  final HttpClientRequest request = await client.getUrl(Uri.parse(url));
  request.followRedirects = true;
  final HttpClientResponse response = await request.close();
  if (response.statusCode != HttpStatus.ok) {
    throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
  }

  final BytesBuilder bytes = BytesBuilder(copy: false);
  await for (final List<int> chunk in response) {
    bytes.add(chunk);
  }
  return bytes.takeBytes();
}

/// 정사각형으로 맞춘다. 세로로 긴 로고를 그냥 늘리면 찌그러지므로, 짧은 변을
/// 기준으로 투명 여백을 덧대 가운데 둔다(동그라미 안에서 잘리지 않게).
img.Image _squared(img.Image source) {
  if (source.width == source.height) return source;

  final int side = source.width > source.height ? source.width : source.height;
  final img.Image canvas = img.Image(width: side, height: side, numChannels: 4);
  return img.compositeImage(
    canvas,
    source,
    dstX: (side - source.width) ~/ 2,
    dstY: (side - source.height) ~/ 2,
  );
}
