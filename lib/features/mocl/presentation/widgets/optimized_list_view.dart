import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OptimizedListView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  _OptimizedListViewState createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<OptimizedListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      viewportBuilder: (BuildContext context, ViewportOffset offset) {
        return Viewport(
          offset: offset,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index < widget.itemCount) {
                    return widget.itemBuilder(context, index);
                  }
                  return null;
                },
                childCount: widget.itemCount,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
