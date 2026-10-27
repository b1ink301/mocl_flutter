import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/floating_pill_tab_bar.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/mute/presentation/state/mute_event_mixin.dart';
import 'package:mocl_flutter/features/mute/presentation/state/mute_state_mixin.dart';

import '../../../core/application/app_provider.dart';

const List<PillTabItem> _muteTabs = [
  (icon: Icons.tag_outlined, selectedIcon: Icons.tag, label: '제목 키워드'),
  (icon: Icons.person_outline, selectedIcon: Icons.person, label: '작성자'),
];

/// 차단(뮤트) 규칙 관리 화면.
///
/// 규칙 종류(제목 키워드 · 작성자)는 위쪽 세그먼트 버튼 대신 홈과 같은 하단
/// 알약형 탭바로 고른다. 입력창은 고른 종류 하나만 다루므로, 종류에 따라
/// 아이콘 · 힌트 · 설명이 함께 바뀐다.
class const MutePage({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<MutePage> createState() => _MutePageState();
}

class _MutePageState()
    extends ConsumerState<MutePage>
    with MuteState, MuteEvent {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  MuteType _type = MuteType.keyword;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isKeyword => _type == MuteType.keyword;

  void _selectType(int index) {
    final MuteType next = index == 0 ? MuteType.keyword : MuteType.user;
    if (next == _type) return;
    setState(() => _type = next);
  }

  void _showMessage(String message, {SnackBarAction? action}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        // 하단 탭바에 가리지 않도록 살짝 띄운다.
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        action: action,
      ),
    );
  }

  void _add(List<MuteRule> rules) {
    final String pattern = _controller.text.trim();
    if (pattern.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    final bool exists = rules.any(
      (r) =>
          r.type == _type && r.pattern.toLowerCase() == pattern.toLowerCase(),
    );
    if (exists) {
      _showMessage('이미 등록된 규칙입니다.');
      return;
    }
    addMuteRule(
      ref,
      MuteRule(
        pattern: pattern,
        type: _type,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _remove(MuteRule rule) {
    removeMuteRule(ref, rule);
    _showMessage(
      '\'${rule.pattern}\' 차단을 해제했습니다.',
      action: SnackBarAction(
        label: '실행취소',
        onPressed: () => addMuteRule(ref, rule),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = muteRulesState(ref);
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;
    final titleStyle = ref.watch(appbarTextStyleProvider);
    final appBarTheme = theme.appBarTheme;
    final List<MuteRule> allRules = async.asData?.value ?? const <MuteRule>[];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            // 목록이 탭바 뒤로 흘러가며 비치도록 본문을 바 뒤까지 확장한다.
            extendBody: true,
            appBar: AppBar(
              backgroundColor: appBarTheme.backgroundColor,
              title: Text('차단(뮤트)', style: titleStyle),
              scrolledUnderElevation: 0,
              titleSpacing: 0,
            ),
            body: Column(
              children: [
                _MuteInputField(
                  controller: _controller,
                  focusNode: _focusNode,
                  isKeyword: _isKeyword,
                  onSubmit: () => _add(allRules),
                ),
                Expanded(
                  child: async.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('불러오기 실패: $e')),
                    data: (rules) {
                      final List<MuteRule> filtered = rules
                          .where((r) => r.type == _type)
                          .toList(growable: false);
                      if (filtered.isEmpty) {
                        return _MuteEmptyView(isKeyword: _isKeyword);
                      }
                      return _MuteRuleList(rules: filtered, onRemove: _remove);
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: FloatingPillTabBar(
              items: _muteTabs,
              selectedIndex: _isKeyword ? 0 : 1,
              onSelected: _selectType,
            ),
          ),
        ),
      ),
    );
  }
}

/// 규칙 입력 줄. 둥근 채움형 입력창 안에 지우기 · 추가 버튼을 함께 둔다.
class const _MuteInputField({
  required final TextEditingController controller,
  required final FocusNode focusNode,
  required final bool isKeyword,
  required final VoidCallback onSubmit,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 입력 내용에 따라 지우기 · 추가 버튼 상태만 다시 그린다.
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final bool canAdd = value.text.trim().isNotEmpty;
              return TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onSubmit(),
                decoration: InputDecoration(
                  hintText: isKeyword ? '차단할 제목 키워드' : '차단할 작성자 닉네임',
                  prefixIcon: Icon(
                    isKeyword ? Icons.tag : Icons.person_outline,
                    size: 20,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (canAdd)
                        IconButton(
                          tooltip: '지우기',
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: controller.clear,
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 6, 4),
                        child: FilledButton(
                          onPressed: canAdd ? onSubmit : null,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            minimumSize: const Size(0, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('추가'),
                        ),
                      ),
                    ],
                  ),
                  // 아이콘 두 개가 들어가도 잘리지 않게 넉넉히 잡는다.
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 48,
                    maxHeight: 48,
                  ),
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest.withValues(
                    alpha: 0.55,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: _border(scheme.outlineVariant, 1),
                  enabledBorder: _border(scheme.outlineVariant, 1),
                  focusedBorder: _border(theme.focusColor, 1.6),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              isKeyword
                  ? '제목에 이 키워드가 들어간 글을 목록에서 숨깁니다.'
                  : '이 작성자가 쓴 글을 목록에서 숨깁니다.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static OutlineInputBorder _border(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: color, width: width),
      );
}

/// 등록된 규칙 목록. 규칙 하나를 알약형 카드로 보여준다.
class const _MuteRuleList({
  required final List<MuteRule> rules,
  required final ValueChanged<MuteRule> onRemove,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // extendBody 로 Scaffold 가 탭바 높이를 bottom padding 에 더해준다.
    final double bottom = MediaQuery.of(context).padding.bottom;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottom + 16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: rules.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final MuteRule rule = rules[i];
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.35,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 2, 6, 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              rule.pattern,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              tooltip: '차단 해제',
              icon: const Icon(Icons.close),
              onPressed: () => onRemove(rule),
            ),
          ),
        );
      },
    );
  }
}

/// 규칙이 하나도 없을 때의 안내.
class const _MuteEmptyView({required final bool isKeyword})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color muted = theme.hintColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 72),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isKeyword ? Icons.tag : Icons.person_outline,
              size: 44,
              color: muted.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              isKeyword ? '차단한 제목 키워드가 없습니다.' : '차단한 작성자가 없습니다.',
              style: theme.textTheme.bodyLarge?.copyWith(color: muted),
            ),
            const SizedBox(height: 6),
            Text(
              '위 입력창에 추가하면 목록에서 자동으로 숨겨집니다.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
