import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/presentation/widgets/author_info_text.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';

/// 상세 화면 작성자 헤더.
///
/// 앱바가 아니라 본문 맨 위에 놓여 본문과 같이 스크롤된다. 앱바 확장 영역은
/// 메인 · 목록과 같이 제목만 쓴다([DetailAppBar]). 스크롤 중에도 필요한
/// 북마크는 앱바 액션에 있다. 배경과 스크롤 그림자는 앱바가 담당하므로
/// (`appBarTheme.scrolledUnderElevation`) 자체 Material/elevation 을 두지 않는다.
class const DetailHeaderBar({
  super.key,
  required final Details detail,
  required final TextStyle style,
}) extends StatelessWidget {
  /// 행 최소 높이. 북마크 버튼(아이콘 20 + 상하 패딩 4)이 있던 시절의 높이를
  /// 유지해, 닉네임 이미지가 없는 글에서도 헤더 높이가 들쭉날쭉하지 않게 한다.
  static const double _kRowMinHeight = 28.0;

  /// 행 위아래 여백(구분선과의 간격).
  static const double _kVerticalPadding = 4.0;

  List<Widget>? _buildLikeView() =>
      detail.likeCount.isNotEmpty && detail.likeCount != '0'
      ? [
          const SizedBox(width: 10),
          PlainIcon(Icons.favorite_outline, color: style.color!, size: 17),
          const SizedBox(width: 4),
          PlainText(detail.likeCount, style: style),
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
            right: 16,
            top: _kVerticalPadding,
            bottom: _kVerticalPadding,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _kRowMinHeight),
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
              ],
            ),
          ),
        ),
        const PlainDividerWidget(indent: 16, endIndent: 16),
      ],
    );
  }
}
