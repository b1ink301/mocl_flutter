import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

import 'plain_text.dart';

/// 말머리 뜻에 따른 태그 색. 사이트가 달라도 같은 뜻이면 같은 색으로 보인다.
enum CategoryTone(final Color light, final Color dark) {
  coral(MoclColors.tagCoralLight, MoclColors.tagCoralDark),
  blue(MoclColors.tagBlueLight, MoclColors.tagBlueDark),
  green(MoclColors.tagGreenLight, MoclColors.tagGreenDark),
  amber(MoclColors.tagAmberLight, MoclColors.tagAmberDark),
  violet(MoclColors.tagVioletLight, MoclColors.tagVioletDark),
  slate(MoclColors.tagSlateLight, MoclColors.tagSlateDark);

  Color color(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  // 위에서부터 먼저 맞는 것을 쓴다. 모르는 말머리는 차분한 회색(slate).
  static final List<(CategoryTone, RegExp)> _rules = [
    (blue, RegExp(r'질문|q&a|문의|도움', caseSensitive: false)),
    (green, RegExp(r'정보|팁|뉴스|강좌|소식')),
    (amber, RegExp(r'유머|잡담|자유|짤')),
    (violet, RegExp(r'사용기|후기|리뷰')),
    (
      coral,
      RegExp(
        r'핫딜|이슈|베스트|인기|11번가|쿠팡|g마켓|지마켓|옥션|위메프|티몬|알리',
        caseSensitive: false,
      ),
    ),
  ];

  // 같은 말머리가 목록에 반복해서 나오므로 정규식 매칭 결과를 기억한다.
  static final Map<String, CategoryTone> _cache = {};

  static CategoryTone of(String label) {
    final cached = _cache[label];
    if (cached != null) return cached;
    if (_cache.length >= 256) _cache.clear();
    var tone = slate;
    for (final (t, r) in _rules) {
      if (r.hasMatch(label)) {
        tone = t;
        break;
      }
    }
    return _cache[label] = tone;
  }
}

/// 말머리 태그. 옅은 색 배경 + 진한 글자(댓글 배지와 같은 톤).
///
/// 크기는 [fontSize] 에 비례한다(11.5 기준 높이 ≈ 20.7, 최대 폭 ≈ 97).
class const CategoryTag(
  final String label, {
  super.key,
  required final Brightness brightness,
  final double fontSize = 11.5,
  final Color? dimmedColor,
}) extends StatelessWidget {
  static const double _lineHeight = 1.2;
  static const double _vPadding = 0.3;

  @override
  Widget build(BuildContext context) {
    // 읽은 글은 제목처럼 흐린 색으로 바꾼다.
    final Color color = dimmedColor ?? CategoryTone.of(label).color(brightness);
    final double bgAlpha = dimmedColor != null
        ? 0.12
        : (brightness == Brightness.dark ? 0.17 : 0.11);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: fontSize * 8.4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: bgAlpha),
          borderRadius: BorderRadius.circular(fontSize * 0.52),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: fontSize * 0.6,
            vertical: fontSize * _vPadding,
          ),
          child: PlainText(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: _lineHeight,
              fontFamily: kAppFontFamily,
            ),
            strutStyle: StrutStyle(
              fontSize: fontSize,
              height: _lineHeight,
              forceStrutHeight: true,
            ),
          ),
        ),
      ),
    );
  }
}

/// 제목 앞에 붙은 "[말머리]" 를 뗀다. 태그로 따로 보여줄 때 두 번 나오지 않게.
String stripCategoryPrefix(String title, String category) {
  if (category.isEmpty) return title;
  final prefix = '[$category]';
  return title.startsWith(prefix)
      ? title.substring(prefix.length).trimLeft()
      : title;
}

/// 말머리 태그를 첫 줄 앞에 인라인으로 붙인 제목. 긴 제목은 태그 옆에서
/// 이어서 줄바꿈되고, [maxLines] 를 넘으면 말줄임 처리된다.
class const CategoryTitleText({
  super.key,
  required final String title,
  required final String category,
  required final TextStyle style,
  required final Brightness brightness,
  final bool dimmed = false,
  final int? maxLines,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (category.isEmpty) {
      return PlainText(
        title,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final double fontSize = (style.fontSize ?? 16) * 0.72;
    return RichText(
      text: TextSpan(
        style: style.fontFamily == null
            ? style.copyWith(fontFamily: kAppFontFamily)
            : style,
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(right: fontSize * 0.52),
              child: CategoryTag(
                category,
                brightness: brightness,
                fontSize: fontSize,
                dimmedColor: dimmed ? style.color : null,
              ),
            ),
          ),
          TextSpan(text: stripCategoryPrefix(title, category)),
        ],
      ),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
