import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

/// 사이트(또는 게시판)를 나타내는 동그란 아이콘.
///
/// 세 단계로 물러난다.
///  1. 게시판 아이콘 주소([iconUrl])가 있으면 그 그림 — 네이버카페처럼 게시판마다
///     다른 그림을 주는 곳에서 가장 정확하다.
///  2. 없으면 사이트 로고 에셋(`assets/icons/`) — 사이트를 로고로 알아보는 쪽이
///     이름 두 글자보다 훨씬 빠르다.
///  3. 로고도 없으면 사이트 이름 앞 두 글자를 딴 색 배지.
///
/// 게시판 목록은 사이트마다 아이콘 유무가 제각각이라 그대로 두면 어떤 줄은
/// 그림이 있고 어떤 줄은 비어 들쭉날쭉해 보인다. 빈칸을 남기지 않고 항상 같은
/// 크기의 동그라미를 채워 줄을 가지런히 맞춘다.
class const SiteAvatar({
  super.key,
  required final SiteType siteType,
  final String iconUrl = '',
  final double radius = 18,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (iconUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(iconUrl),
      );
    }

    final String? asset = _assetOf(siteType);
    if (asset != null) {
      final Widget badge = _Badge(siteType: siteType, radius: radius);
      return SizedBox.square(
        dimension: radius * 2,
        child: ClipOval(
          child: ColoredBox(
            // 로고가 투명 배경에 어두운 색으로 그려진 경우(긱뉴스 등) 다크
            // 테마에서 묻히므로, 파비콘이 원래 전제하는 밝은 바탕을 깔아 준다.
            color: Colors.white,
            child: Image.asset(
              asset,
              fit: BoxFit.cover,
              // 에셋이 빠졌다면(리소스 누락) 빈 흰 원이 남지 않게 배지로 돌아간다.
              errorBuilder: (_, _, _) => badge,
            ),
          ),
        ),
      );
    }

    return _Badge(siteType: siteType, radius: radius);
  }
}

/// 사이트 이름 앞 두 글자를 딴 색 배지.
class const _Badge({
  required final SiteType siteType,
  required final double radius,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: _colorOf(siteType),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: radius * 0.18),
      child: FittedBox(
        // 'MLBPARK' 처럼 글자가 넓은 이름도 동그라미 안에 들어오게 줄인다.
        fit: BoxFit.scaleDown,
        child: Text(
          _initialsOf(siteType.title),
          maxLines: 1,
          style: TextStyle(
            fontSize: radius * 0.66,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

/// 사이트 이름 앞 두 글자. 한글은 두 글자면 알아보기 충분하다.
String _initialsOf(String title) {
  final String trimmed = title.trim();
  if (trimmed.isEmpty) return '?';
  return trimmed.length <= 2 ? trimmed : trimmed.substring(0, 2);
}

/// 사이트 로고 에셋 경로. `tool/fetch_site_icons.dart` 가 만든다.
///
/// 원본 파비콘이 너무 작아(뽐뿌는 16×15) 확대하면 뭉개지는 곳은 일부러 비워
/// 두었다. 그런 사이트는 색 배지가 더 깔끔하다.
String? _assetOf(SiteType siteType) => switch (siteType) {
  SiteType.arcalive => 'assets/icons/arcalive.png',
  SiteType.bobaedream => 'assets/icons/bobaedream.png',
  SiteType.clien => 'assets/icons/clien.png',
  SiteType.cook82 => 'assets/icons/cook82.png',
  SiteType.damoang => 'assets/icons/damoang.png',
  SiteType.dcinside => 'assets/icons/dcinside.png',
  SiteType.dogdrip => 'assets/icons/dogdrip.png',
  SiteType.geekNews => 'assets/icons/geekNews.png',
  SiteType.instiz => 'assets/icons/instiz.png',
  SiteType.inven => 'assets/icons/inven.png',
  SiteType.meeco => 'assets/icons/meeco.png',
  SiteType.mlbpark => 'assets/icons/mlbpark.png',
  SiteType.nate => 'assets/icons/nate.png',
  SiteType.naverCafe => 'assets/icons/naverCafe.png',
  SiteType.reddit => 'assets/icons/reddit.png',
  SiteType.ruliweb => 'assets/icons/ruliweb.png',
  SiteType.theqoo => 'assets/icons/theqoo.png',
  SiteType.ppomppu => null,
};

/// 사이트마다 고정된 배지 색. 라이트/다크 어디서도 흰 글씨가 읽히도록
/// 중간 채도로 골랐다. 사이트를 색으로도 구분할 수 있게 이웃한 항목끼리
/// 색이 겹치지 않게 배치했다.
Color _colorOf(SiteType siteType) => switch (siteType) {
  SiteType.arcalive => const Color(0xFF3E7BC4),
  SiteType.bobaedream => const Color(0xFF1F5FA8),
  SiteType.clien => const Color(0xFF2F6FB5),
  SiteType.cook82 => const Color(0xFFC7803A),
  SiteType.damoang => const Color(0xFF3B7F5E),
  SiteType.dcinside => const Color(0xFFB5762F),
  SiteType.dogdrip => const Color(0xFFC3483A),
  SiteType.geekNews => const Color(0xFF566B8C),
  SiteType.instiz => const Color(0xFFC4568F),
  SiteType.inven => const Color(0xFFA8342A),
  SiteType.meeco => const Color(0xFF7A4A9E),
  SiteType.mlbpark => const Color(0xFF3F7A8C),
  SiteType.nate => const Color(0xFFE0562D),
  SiteType.naverCafe => const Color(0xFF2DA44E),
  SiteType.ppomppu => const Color(0xFFA8455F),
  SiteType.reddit => const Color(0xFFE04A1A),
  SiteType.ruliweb => const Color(0xFF5A6FB5),
  SiteType.theqoo => const Color(0xFF8E5AA8),
};
