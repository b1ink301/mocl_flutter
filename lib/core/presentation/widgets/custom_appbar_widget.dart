import 'package:material_ui/material_ui.dart';

class const CustomAppBar({super.key, required final Widget title})
    extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(_calculateHeight());

  double _calculateHeight() {
    // LayoutBuilder를 사용하여 title 위젯의 높이를 계산합니다.
    double titleHeight = 0;
    LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textScaler = MediaQuery.of(context).textScaler;
        final textStyle = Theme.of(context).textTheme.titleLarge;
        final textSpan = TextSpan(text: title.toString(), style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        );
        textPainter.layout(minWidth: 0, maxWidth: constraints.maxWidth);
        titleHeight = textPainter.height;
        return const SizedBox(); // 빈 위젯 반환
      },
    );

    // AppBar의 padding, margin 등을 고려하여 최종 높이를 계산합니다.
    const appBarPadding = 16.0; // 예시 padding 값
    return titleHeight + appBarPadding * 2;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).appBarTheme.backgroundColor;
    return Container(
      padding: const EdgeInsets.all(16.0), // 예시 padding 값
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: const [
          // AppBar 그림자 효과 추가 (선택 사항)
          // ...
        ],
      ),
      child: title,
    );
  }
}
