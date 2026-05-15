import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_search_event_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_search_state_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/list_scope.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/mocl_list_item.dart';

import '../../../core/presentation/widgets/plain_icon.dart';
import '../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../core/presentation/widgets/plain_text.dart';

class ListSearchDelegate extends SearchDelegate {
  final MainItem item;

  ListSearchDelegate({required this.item});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: theme.appBarTheme,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.textTheme.labelMedium,
      ),
      textTheme: TextTheme(titleLarge: theme.textTheme.labelLarge),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    PlainIconButton(
      icon: const PlainIcon(Icons.clear),
      onPressed: () {
        query = ''; // 검색어 초기화
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => PlainIconButton(
    icon: const PlainIcon(Icons.arrow_back),
    onPressed: () {
      close(context, ''); // 검색 종료
    },
  );

  @override
  Widget buildResults(BuildContext context) => _buildResultView(query);

  @override
  Widget buildSuggestions(BuildContext context) => _buildResultView(query);

  Widget _buildResultView(String query) {
    final String searchText = query.trim();
    return ProviderScope(
      overrides: ListSearchEvent.overridesProviderScope(item),
      child: SearchResultView(searchText: searchText),
    );
  }
}

class SearchResultView extends ConsumerStatefulWidget {
  final String searchText;

  const SearchResultView({super.key, required this.searchText});

  @override
  SearchResultViewState createState() => SearchResultViewState();
}

class SearchResultViewState extends ConsumerState<SearchResultView>
    with ListSearchState, ListSearchEvent {
  @override
  void initState() {
    super.initState();
    _triggerSearch();
  }

  @override
  void didUpdateWidget(SearchResultView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchText != widget.searchText) {
      _triggerSearch();
    }
  }

  void _triggerSearch() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => handleSearch(ref, widget.searchText),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return listState(ref).when(
      data: (Either<Failure, List<ListItem>> data) => data.fold(
        (Failure f) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PlainText(
              f.message,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        (List<ListItem> items) {
          if (items.isEmpty) {
            if (widget.searchText.isEmpty) {
              return const SizedBox.shrink();
            }
            return const Center(child: Text('검색 결과가 없습니다.'));
          }

          return ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (BuildContext context, int index) =>
                ListItemScope(item: items[index], child: const MoclListItem()),
            separatorBuilder: (BuildContext context, int index) =>
                const DividerWidget(),
            itemCount: items.length,
          );
        },
      ),
      error: (e, s) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            e.toString(),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ),
      loading: () => const LoadingWidget(),
    );
  }
}
