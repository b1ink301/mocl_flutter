import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/mute/presentation/state/mute_event_mixin.dart';
import 'package:mocl_flutter/features/mute/presentation/state/mute_state_mixin.dart';

class MutePage extends ConsumerStatefulWidget {
  const MutePage({super.key});

  @override
  ConsumerState<MutePage> createState() => _MutePageState();
}

class _MutePageState extends ConsumerState<MutePage> with MuteState, MuteEvent {
  final TextEditingController _controller = TextEditingController();
  MuteType _type = MuteType.keyword;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final String pattern = _controller.text.trim();
    if (pattern.isEmpty) return;
    final rule = MuteRule(
      pattern: pattern,
      type: _type,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    addMuteRule(ref, rule);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final async = muteRulesState(ref);

    return Scaffold(
      appBar: AppBar(title: const Text('차단(뮤트)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<MuteType>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: MuteType.keyword, label: Text('제목 키워드')),
                    ButtonSegment(value: MuteType.user, label: Text('작성자')),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) => setState(() => _type = s.first),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _add(),
                        decoration: InputDecoration(
                          hintText: _type == MuteType.keyword
                              ? '차단할 제목 키워드'
                              : '차단할 작성자 닉네임',
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: _add, child: const Text('추가')),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('불러오기 실패: $e')),
              data: (rules) {
                if (rules.isEmpty) {
                  return const Center(child: Text('차단 규칙이 없습니다.'));
                }
                return ListView.separated(
                  itemCount: rules.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = rules[i];
                    return ListTile(
                      leading: Icon(
                        r.type == MuteType.keyword
                            ? Icons.tag
                            : Icons.person_outline,
                      ),
                      title: Text(r.pattern),
                      subtitle: Text(
                        r.type == MuteType.keyword ? '제목 키워드' : '작성자',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => removeMuteRule(ref, r),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
