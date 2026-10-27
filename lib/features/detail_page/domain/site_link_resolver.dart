import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

/// 본문 링크를 앱 상세 화면으로 열 때 넘기는 값.
///
/// 목록을 거치지 않고 들어오므로 [item] 은 파서가 상세를 받는 데 필요한
/// 필드(`url` · `board` · `id`)만 채운다. 제목은 상세를 받은 뒤 채워진다.
class const SiteLink(final SiteType siteType, final ListItem item);

/// 모클이 지원하는 사이트의 **게시글** 링크를 [SiteLink] 로 바꾼다.
///
/// 게시판 목록 · 검색 · 이미지 등 글이 아닌 링크는 null 을 돌려줘 브라우저로
/// 열리게 한다. PC 주소는 각 파서가 읽는 모바일 주소로 바꾼다(파서는 목록에서
/// 얻은 주소 형식만 안다).
abstract final class SiteLinkResolver() {
  static SiteLink? resolve(String url) {
    final Uri? uri = Uri.tryParse(url.startsWith('//') ? 'https:$url' : url);
    if (uri == null || !uri.scheme.startsWith('http')) return null;

    final String host = uri.host.toLowerCase();
    final List<String> segs = uri.pathSegments
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
    final Map<String, String> q = uri.queryParameters;

    return switch (host) {
      'arca.live' => _arcalive(segs),
      'm.bobaedream.co.kr' ||
      'www.bobaedream.co.kr' ||
      'bobaedream.co.kr' => _bobaedream(segs, q),
      'm.clien.net' || 'www.clien.net' || 'clien.net' => _clien(segs),
      'www.82cook.com' || 'm.82cook.com' || '82cook.com' => _cook82(q),
      'damoang.net' || 'www.damoang.net' => _damoang(segs),
      'm.dcinside.com' || 'gall.dcinside.com' => _dcinside(host, segs, q),
      'www.dogdrip.net' || 'dogdrip.net' => _dogdrip(segs, q),
      'news.hada.io' => _geekNews(segs, q),
      'www.instiz.net' || 'instiz.net' || 'm.instiz.net' => _instiz(segs),
      'm.inven.co.kr' || 'www.inven.co.kr' || 'inven.co.kr' => _inven(segs),
      'meeco.kr' || 'www.meeco.kr' => _meeco(segs, q),
      'mlbpark.donga.com' => _mlbpark(uri, q),
      'm.pann.nate.com' || 'pann.nate.com' => _nate(segs),
      'm.cafe.naver.com' || 'cafe.naver.com' => _naverCafe(segs, q),
      'm.ppomppu.co.kr' ||
      'www.ppomppu.co.kr' ||
      'ppomppu.co.kr' => _ppomppu(segs, q),
      'www.reddit.com' ||
      'reddit.com' ||
      'old.reddit.com' ||
      'm.reddit.com' => _reddit(segs),
      'm.ruliweb.com' || 'bbs.ruliweb.com' || 'ruliweb.com' => _ruliweb(segs),
      'theqoo.net' || 'www.theqoo.net' => _theqoo(segs, q),
      _ => null,
    };
  }

  // ── 사이트별 규칙 ──────────────────────────────────────────────────────

  /// `/b/{board}/{id}`
  static SiteLink? _arcalive(List<String> segs) {
    if (segs.length < 3 || segs[0] != 'b') return null;
    final int? id = _id(segs[2]);
    if (id == null) return null;
    return _link(
      SiteType.arcalive,
      'https://arca.live/b/${segs[1]}/$id',
      board: segs[1],
      id: id,
    );
  }

  /// 모바일 `/board/bbs_view/{code}/{id}/...`, PC `/view?code={code}&No={id}`
  static SiteLink? _bobaedream(List<String> segs, Map<String, String> q) {
    String? code;
    int? id;
    final int idx = segs.indexOf('bbs_view');
    if (idx >= 0 && idx + 2 < segs.length) {
      code = segs[idx + 1];
      id = _id(segs[idx + 2]);
    } else if (segs.lastOrNull == 'view') {
      code = q['code'];
      id = _id(q['No'] ?? q['no']);
    }
    if (code == null || code.isEmpty || id == null) return null;
    return _link(
      SiteType.bobaedream,
      'https://m.bobaedream.co.kr/board/bbs_view/$code/$id',
      board: code,
      id: id,
    );
  }

  /// `/service/board/{board}/{id}`
  static SiteLink? _clien(List<String> segs) {
    if (segs.length < 4 || segs[0] != 'service' || segs[1] != 'board') {
      return null;
    }
    final int? id = _id(segs[3]);
    if (id == null) return null;
    return _link(
      SiteType.clien,
      'https://m.clien.net/service/board/${segs[2]}/$id',
      board: segs[2],
      id: id,
    );
  }

  /// `/entiz/read.php?bn={board}&num={id}`
  static SiteLink? _cook82(Map<String, String> q) {
    final String? bn = q['bn'];
    final int? id = _id(q['num']);
    if (bn == null || bn.isEmpty || id == null) return null;
    return _link(
      SiteType.cook82,
      'https://www.82cook.com/entiz/read.php?bn=$bn&num=$id',
      board: bn,
      id: id,
    );
  }

  /// `/{board}/{id}`
  static SiteLink? _damoang(List<String> segs) {
    if (segs.length != 2) return null;
    final int? id = _id(segs[1]);
    if (id == null) return null;
    return _link(
      SiteType.damoang,
      'https://damoang.net/${segs[0]}/$id',
      board: segs[0],
      id: id,
    );
  }

  /// 모바일 `/board/{gall}/{no}`,
  /// PC `/(mgallery/)board/view/?id={gall}&no={no}`
  static SiteLink? _dcinside(
    String host,
    List<String> segs,
    Map<String, String> q,
  ) {
    String? board;
    int? id;
    if (host == 'm.dcinside.com') {
      if (segs.length >= 3 && segs[0] == 'board') {
        board = segs[1];
        id = _id(segs[2]);
      }
    } else if (segs.contains('view') && !segs.contains('mini')) {
      board = q['id'];
      id = _id(q['no']);
    }
    if (board == null || board.isEmpty || id == null) return null;
    return _link(
      SiteType.dcinside,
      'https://m.dcinside.com/board/$board/$id',
      board: board,
      id: id,
    );
  }

  /// `/{board}/{id}`, `/{id}`, `?document_srl={id}`
  static SiteLink? _dogdrip(List<String> segs, Map<String, String> q) {
    final int? srl = _id(q['document_srl']);
    if (srl != null) {
      return _link(
        SiteType.dogdrip,
        'https://www.dogdrip.net/$srl',
        board: q['mid'] ?? '',
        id: srl,
      );
    }
    if (segs.isEmpty || segs.length > 2) return null;
    final int? id = _id(segs.last);
    if (id == null) return null;
    final String board = segs.length == 2 ? segs[0] : '';
    return _link(
      SiteType.dogdrip,
      'https://www.dogdrip.net/${segs.join('/')}',
      board: board,
      id: id,
    );
  }

  /// `/topic?id={id}`
  static SiteLink? _geekNews(List<String> segs, Map<String, String> q) {
    if (segs.firstOrNull != 'topic') return null;
    final int? id = _id(q['id']);
    if (id == null) return null;
    return _link(
      SiteType.geekNews,
      'https://news.hada.io/topic?id=$id',
      board: '',
      id: id,
    );
  }

  /// `/pt/{id}` (파서가 읽는 게시판은 pt 뿐)
  static SiteLink? _instiz(List<String> segs) {
    if (segs.length < 2 || segs[0] != 'pt') return null;
    final int? id = _id(segs[1]);
    if (id == null) return null;
    return _link(
      SiteType.instiz,
      'https://www.instiz.net/pt/$id',
      board: 'pt',
      id: id,
    );
  }

  /// `/board/{slug}/{boardId}/{id}`
  static SiteLink? _inven(List<String> segs) {
    if (segs.length < 4 || segs[0] != 'board') return null;
    final int? id = _id(segs[3]);
    if (id == null || _id(segs[2]) == null) return null;
    return _link(
      SiteType.inven,
      'https://m.inven.co.kr/board/${segs[1]}/${segs[2]}/$id',
      board: segs[2],
      id: id,
    );
  }

  /// `/{board}/{id}`, `/index.php?mid={board}&document_srl={id}`
  static SiteLink? _meeco(List<String> segs, Map<String, String> q) {
    String? board;
    int? id;
    if (segs.length == 2) {
      board = segs[0];
      id = _id(segs[1]);
    } else {
      board = q['mid'];
      id = _id(q['document_srl']);
    }
    if (board == null || board.isEmpty || id == null) return null;
    return _link(
      SiteType.meeco,
      'https://meeco.kr/$board/$id',
      board: board,
      id: id,
    );
  }

  /// `/mp/b.php?b={board}&id={id}&m=view`
  static SiteLink? _mlbpark(Uri uri, Map<String, String> q) {
    if (!uri.path.endsWith('b.php')) return null;
    final String board = q['b'] ?? '';
    final int? id = _id(q['id']);
    if (board.isEmpty || id == null || (q['m'] ?? 'view') != 'view') {
      return null;
    }
    return _link(
      SiteType.mlbpark,
      'https://mlbpark.donga.com/mp/b.php?m=view&b=$board&id=$id',
      board: board,
      id: id,
    );
  }

  /// `/talk/{id}`
  static SiteLink? _nate(List<String> segs) {
    if (segs.length < 2 || segs[0] != 'talk') return null;
    final int? id = _id(segs[1]);
    if (id == null) return null;
    return _link(
      SiteType.nate,
      'https://m.pann.nate.com/talk/$id',
      board: 'ranking',
      id: id,
    );
  }

  /// `/ca-fe/(web/)cafes/{cafeId}/articles/{id}`,
  /// `ArticleRead.nhn?clubid={cafeId}&articleid={id}`.
  /// `cafe.naver.com/{카페이름}/{id}` 는 숫자 카페 id 를 알 수 없어 건너뛴다.
  static SiteLink? _naverCafe(List<String> segs, Map<String, String> q) {
    int? cafeId;
    int? id;
    final int cafes = segs.indexOf('cafes');
    if (cafes >= 0 &&
        cafes + 3 < segs.length &&
        segs[cafes + 2] == 'articles') {
      cafeId = _id(segs[cafes + 1]);
      id = _id(segs[cafes + 3]);
    } else {
      cafeId = _id(q['clubid']);
      id = _id(q['articleid']);
    }
    if (cafeId == null || id == null) return null;
    return _link(SiteType.naverCafe, '', board: '$cafeId', id: id);
  }

  /// 모바일 `/new/bbs_view.php?id={board}&no={id}`,
  /// PC `/zboard/view.php?id={board}&no={id}`
  static SiteLink? _ppomppu(List<String> segs, Map<String, String> q) {
    final String last = segs.lastOrNull ?? '';
    if (last != 'bbs_view.php' && last != 'view.php') return null;
    final String board = q['id'] ?? '';
    final int? id = _id(q['no']);
    if (board.isEmpty || id == null) return null;
    return _link(
      SiteType.ppomppu,
      'https://m.ppomppu.co.kr/new/bbs_view.php?id=$board&no=$id',
      board: board,
      id: id,
    );
  }

  /// `/r/{sub}/comments/{postId}/...`. 레딧 파서는 url 자리에 글 id 를 둔다.
  static SiteLink? _reddit(List<String> segs) {
    if (segs.length < 4 || segs[0] != 'r' || segs[2] != 'comments') {
      return null;
    }
    final String postId = segs[3];
    if (postId.isEmpty) return null;
    return _link(SiteType.reddit, postId, board: segs[1], id: postId.hashCode);
  }

  /// `/{분류}/board/{boardId}/read/{id}`
  static SiteLink? _ruliweb(List<String> segs) {
    final int board = segs.indexOf('board');
    final int read = segs.indexOf('read');
    if (board < 0 || read != board + 2 || read + 1 >= segs.length) {
      return null;
    }
    final String boardId = segs[board + 1];
    final int? id = _id(segs[read + 1]);
    if (id == null) return null;
    return _link(
      SiteType.ruliweb,
      'https://m.ruliweb.com/${segs.take(read + 2).join('/')}',
      board: boardId,
      id: id,
    );
  }

  /// `/{board}/{id}`, `/index.php?mid={board}&document_srl={id}`
  static SiteLink? _theqoo(List<String> segs, Map<String, String> q) {
    String? board;
    int? id;
    if (segs.length == 2) {
      board = segs[0];
      id = _id(segs[1]);
    } else {
      board = q['mid'];
      id = _id(q['document_srl']);
    }
    if (board == null || board.isEmpty || id == null) return null;
    return _link(
      SiteType.theqoo,
      'https://theqoo.net/$board/$id',
      board: board,
      id: id,
    );
  }

  // ── 공통 ──────────────────────────────────────────────────────────────

  static int? _id(String? s) {
    final int? id = int.tryParse(s ?? '');
    return id != null && id > 0 ? id : null;
  }

  static SiteLink _link(
    SiteType siteType,
    String url, {
    required String board,
    required int id,
  }) => SiteLink(
    siteType,
    ListItem.empty().copyWith(id: id, url: url, board: board),
  );
}
