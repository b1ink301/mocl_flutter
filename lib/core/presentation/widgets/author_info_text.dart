import 'package:flutter/material.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';

/// 닉네임과 메타([info]: 시간ㆍ조회수 등)를 한 줄로 조합해 보여준다.
///
/// 닉네임은 항상 볼드로, 원글 작성자(OP)일 때는 [Theme.focusColor](코랄)로 칠한다.
/// [info] 에는 더 이상 닉네임이 포함되지 않으며(파서 단계에서 제거), 닉네임은
/// [nickName] 으로 별도 전달받아 여기서 조합한다.
///
/// 레이아웃: 닉네임이 길면 말줄임 처리하고, 시간ㆍ조회수는 항상 보이도록 한다.
class AuthorInfoText extends StatelessWidget {
  static const String _sep = 'ㆍ';

  final String nickName;
  final String info;
  final bool isAuthor;
  final TextStyle style;
  final int maxLines;

  const AuthorInfoText({
    super.key,
    required this.nickName,
    required this.info,
    required this.style,
    this.isAuthor = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // 닉네임이 없으면(닉을 이미지로만 표시하는 사이트 등) 메타만 보여준다.
    if (nickName.isEmpty) {
      return PlainText(
        info,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    // final nickColor = Theme.of(context).focusColor;
    final Color nickColor = isAuthor
        ? Theme.of(context).focusColor
        : (style.color ?? const Color(0xFF181A1F));
    final TextStyle nickStyle = style.copyWith(
      fontWeight: FontWeight.w500,
      color: nickColor,
    );

    if (info.isEmpty) {
      return PlainText(
        nickName,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: nickStyle,
      );
    }

    final TextStyle infoStyle = style.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: style.fontSize! - 1.4,
    );

    return Row(
      crossAxisAlignment: .center,
      children: [
        // 닉네임은 남는 폭 안에서 말줄임.
        Flexible(
          child: PlainText(
            nickName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: nickStyle,
          ),
        ),
        // 시간ㆍ조회수는 잘리지 않고 항상 노출.
        PlainText('님$_sep$info', maxLines: 1, style: infoStyle),
      ],
    );
  }
}
