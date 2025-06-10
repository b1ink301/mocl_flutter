import 'package:flutter/material.dart';

class CachedItemBuilder extends StatefulWidget {
  final Widget Function() builder;

  const CachedItemBuilder({super.key, required this.builder});

  @override
  State<CachedItemBuilder> createState() => _CachedItemBuilderState();
}

class _CachedItemBuilderState extends State<CachedItemBuilder>
    with AutomaticKeepAliveClientMixin {
  late Widget _cachedWidget;

  @override
  void initState() {
    super.initState();
    _cachedWidget = widget.builder();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _cachedWidget;
  }

  @override
  bool get wantKeepAlive => true;
}
