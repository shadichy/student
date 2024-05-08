import 'package:flutter/material.dart';

class SimpleListBuilder extends StatelessWidget {
  final Widget Function(int index) builder;
  final int itemCount;
  const SimpleListBuilder({
    super.key,
    required this.builder,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(itemCount, builder),
    );
  }
}
