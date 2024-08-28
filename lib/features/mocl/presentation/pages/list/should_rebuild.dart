import 'package:flutter/material.dart';

class ShouldRebuild<T extends Widget> extends StatefulWidget {
  final T child;
  final bool Function(T, T) shouldRebuild;

  const ShouldRebuild({
    super.key,
    required this.child,
    required this.shouldRebuild,
  });

  @override
  _ShouldRebuildState<T> createState() => _ShouldRebuildState<T>();
}

class _ShouldRebuildState<T extends Widget> extends State<ShouldRebuild<T>> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void didUpdateWidget(ShouldRebuild<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shouldRebuild(oldWidget.child, widget.child)) {
      setState(() {});
    }
  }
}
