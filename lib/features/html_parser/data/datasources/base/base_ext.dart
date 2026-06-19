import 'package:html/dom.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';

extension SortTypeExtension on SortType {
  String toQuery(SiteType siteType) {
    switch (siteType) {
      case SiteType.arcalive:
        return '';
      case SiteType.bobaedream:
        return '';
      case SiteType.cook82:
        return '';
      case SiteType.dcinside:
        return '';
      case SiteType.dogdrip:
        return '';
      case SiteType.clien:
        return switch (this) {
          SortType.recent => '&od=T31',
          SortType.recommend => '&od=T33',
        };
      case SiteType.damoang:
        switch (this) {
          case SortType.recent:
            return '';
          case SortType.recommend:
            final now = DateTime.now();
            final today =
                '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
            return '&&sfl=wr_datetime&sst=wr_good&stx=$today';
        }
      case SiteType.meeco:
        return '';
      case SiteType.inven:
        return '';
      case SiteType.naverCafe:
        return '';
      case SiteType.ppomppu:
        return '';
      case SiteType.settings:
        return '';
      case SiteType.reddit:
        return switch (this) {
          SortType.recent => 'new',
          SortType.recommend => 'hot',
        };
      case SiteType.theqoo:
        return '';
      case SiteType.ruliweb:
        return '';
      case SiteType.geekNews:
        return '';
    }
  }
}

extension StringExtension on String {
  String toUrl(String baseUrl) =>
      isNotEmpty && !startsWith("http") ? '$baseUrl$this' : this;
}

/// `el?.querySelector(sel)?.text.trim() ?? ''` 같은 반복 추출 패턴을 한 줄로.
/// 수신자가 null 이어도 안전하게 빈 값/무동작으로 처리한다.
extension ElementQuery on Element? {
  /// [selector] 로 찾은 첫 요소의 trim 된 텍스트. 없으면 빈 문자열.
  String qText(String selector) =>
      this?.querySelector(selector)?.text.trim() ?? '';

  /// [selector] 로 찾은 첫 요소의 [name] 속성값. 없으면 빈 문자열.
  String qAttr(String selector, String name) =>
      this?.querySelector(selector)?.attributes[name] ?? '';

  /// [selector] 에 매칭되는 모든 요소를 DOM 에서 제거한다.
  void removeAll(String selector) =>
      this?.querySelectorAll(selector).forEach((e) => e.remove());
}

/// [ElementQuery] 와 동일하지만 수신자가 `Document`(= `parse()` 결과) 인 경우.
/// `Document` 와 `Element` 는 공통 상위 타입에 `querySelector` 를 노출하지
/// 않으므로 같은 헬퍼를 문서 레벨에도 제공한다.
extension DocumentQuery on Document? {
  String qText(String selector) =>
      this?.querySelector(selector)?.text.trim() ?? '';

  String qAttr(String selector, String name) =>
      this?.querySelector(selector)?.attributes[name] ?? '';

  void removeAll(String selector) =>
      this?.querySelectorAll(selector).forEach((e) => e.remove());
}
