import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/presentation/widgets/author_info_text.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';

import 'bookmark_icon_button.dart';

/// 상세 화면 작성자 헤더.
///
/// [DetailAppBar] 의 `bottom`(확장 영역)으로 들어가 floating 앱바와 한 몸으로
/// 밀려 올라가고 되돌아온다. 배경과 스크롤 그림자는 앱바가 담당하므로
/// (`appBarTheme.scrolledUnderElevation`) 자체 Material/elevation 을 두지 않는다.
///
/// 높이는 고정이 아니라 [style] 의 폰트 크기에서 계산한다. 사용자가 글자 크기를
/// 키우면 [preferredSize] 도 함께 커져 헤더 콘텐츠가 잘리지 않는다.
class const DetailHeaderBar({
  super.key,
  required final Details detail,
  required final TextStyle style,
}) extends StatelessWidget implements PreferredSizeWidget {
  /// 북마크 버튼(아이콘 20 + 상하 패딩 4)의 높이. 행 안에서 가장 큰 고정 요소라,
  /// 작은 폰트에서는 이 값이 행 높이의 하한이 된다.
  static const double _kIconRowFloor = 28.0;

  /// Row 아래 여백(구분선과의 간격).
  static const double _kBottomPadding = 4.0;

  /// 하단 구분선 두께.
  static const double _kDividerHeight = 1.0;

  @override
  Size get preferredSize {
    // 한 줄 텍스트의 실제 렌더 높이를 폰트 메트릭으로 측정한다. 폰트 크기가
    // 바뀌면 이 값도 바뀌므로 큰 글자에서도 헤더가 잘리지 않는다.
    // (PlainText 와 동일하게 OS 스케일은 무시 — 앱 자체 delta 만 style 에 반영됨.)
    final double textHeight = (TextPainter(
      text: TextSpan(text: '가', style: style),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
    )..layout()).height;

    // 행 높이 = 텍스트와 고정 아이콘 중 큰 값.
    final double rowHeight = textHeight > _kIconRowFloor
        ? textHeight
        : _kIconRowFloor;
    return Size.fromHeight(rowHeight + _kBottomPadding + _kDividerHeight);
  }

  List<Widget>? _buildLikeView() =>
      detail.likeCount.isNotEmpty && detail.likeCount != '0'
      ? [
          const SizedBox(width: 10),
          PlainIcon(Icons.favorite_outline, color: style.color!, size: 17),
          const SizedBox(width: 4),
          PlainText(detail.likeCount, style: style),
          const SizedBox(width: 10),
        ]
      : null;

  @override
  Widget build(BuildContext context) {
    final likeView = _buildLikeView();
    final nickImage = detail.userInfo.nickImage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
            bottom: _kBottomPadding,
          ),
          child: Row(
            children: [
              if (nickImage.isNotEmpty) NickImageWidget(url: nickImage),
              Expanded(
                child: AuthorInfoText(
                  info: detail.info,
                  nickName: detail.userInfo.nickName,
                  isAuthor: true,
                  style: style,
                ),
              ),
              ...?likeView,
              BookmarkIconButton(color: style.color!),
            ],
          ),
        ),
        const PlainDividerWidget(indent: 16, endIndent: 8),
      ],
    );
  }
}
