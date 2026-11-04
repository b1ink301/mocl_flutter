import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';
import 'package:mocl_flutter/features/detail_page/presentation/state/detail_event_mixin.dart';
import 'package:mocl_flutter/features/detail_page/presentation/state/detail_state_mixin.dart';

/// 상세 앱바의 번역 토글 버튼. 번역을 켠 사이트(레딧)에서만 보인다.
///
/// 번역 중에는 아이콘 대신 작은 진행 표시를 두고, 번역본을 보는 동안은 강조색으로
/// 칠해 원문이 아님을 알린다. 번역 중에 다시 누르면 멈추고 원문으로 돌아간다.
class const TranslateIconButton({super.key})
    extends ConsumerWidget
    with DetailState, DetailEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!supportsTranslationState(ref)) return const SizedBox.shrink();
    final translation = translationState(ref);
    final Color primary = Theme.of(context).colorScheme.primary;

    return PlainIconButton(
      onPressed: () async {
        final bool ok = await toggleTranslation(ref);
        if (ok || !context.mounted) return;
        ScaffoldMessenger.maybeOf(context)
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('번역하지 못했어요. 처음이면 번역 언어를 받을 인터넷 연결이 필요해요.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      icon: translation.isTranslating
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: primary),
            )
          : PlainIcon(
              Icons.translate_rounded,
              color: translation.isShowing ? primary : null,
            ),
    );
  }
}
