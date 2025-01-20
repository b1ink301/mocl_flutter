import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_search_proivders.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

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
      textTheme: TextTheme(
        titleLarge: theme.textTheme.labelLarge,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // 검색어 초기화
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // 검색 종료
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final String searchText = query.trim();
    return ProviderScope(overrides: [
      mainItemProvider.overrideWithValue(item),
    ], child: SearchResultView(searchText: searchText));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox.shrink();
  }
}

class SearchResultView extends ConsumerStatefulWidget {
  final String searchText;

  const SearchResultView({
    super.key,
    required this.searchText,
  });

  @override
  SearchResultViewState createState() => SearchResultViewState();
}

class SearchResultViewState extends ConsumerState<SearchResultView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(keywordNotifierProvider.notifier).setKeyword(widget.searchText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultAsync = ref.watch(reqSearchListDataProvider);
    return resultAsync.when(
      data: (Either<Failure, List<ListItem>> data) => data.fold(
          (Failure f) => Text(f.message, style: const TextStyle(color: Colors.black)),
          (List<ListItem> items) => ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  final ListItem item = items[index];
                  return MoclListItem(
                    key: item.key,
                    item: item,
                    index: index,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const DividerWidget(),
                itemCount: items.length,
              )),
      error: (e, s) => Text(e.toString(), style: const TextStyle(color: Colors.black)),
      loading: () => const LoadingWidget(),
    );
  }
}
