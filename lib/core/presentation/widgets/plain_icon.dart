import 'package:material_ui/material_ui.dart';

class const PlainIcon(
  final IconData icon, {
  super.key,

  /// null 이면 주변 [IconTheme]/[DefaultTextStyle] 색을 따른다.
  /// (앱바 액션은 AppBar 의 foregroundColor 로 IconTheme 이 설정되므로
  /// Paper 테마의 밝은 앱바에서 자동으로 잉크색이 된다.)
  final Color? color,
  final double size = 24,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color resolved =
        color ??
        IconTheme.of(context).color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF181A1F);
    // 아이콘 폰트는 라인박스가 size 보다 크고 글리프가 베이스라인 기준으로
    // 놓이므로, 맨 RichText 로 그리면 같은 줄의 텍스트와 세로 중심이 어긋난다.
    // Flutter 의 Icon 과 동일하게 height:1.0 + even leading + size x size 정사각
    // 박스 중앙정렬로 맞춘다.
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: RichText(
          overflow: TextOverflow.visible, // 잘리지 않게
          textDirection: TextDirection.ltr, // 명시 → Directionality 의존 X
          textScaler: TextScaler.noScaling,
          text: TextSpan(
            text: String.fromCharCode(icon.codePoint),
            style: TextStyle(
              inherit: false,
              fontFamily: icon.fontFamily,
              package: icon.fontPackage,
              fontFamilyFallback: icon.fontFamilyFallback,
              fontSize: size,
              height: 1.0,
              leadingDistribution: TextLeadingDistribution.even,
              color: resolved,
            ),
          ),
        ),
      ),
    );
  }
}
