import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  final Widget child;
  final void Function()? target;
  final Color? color;
  const ClickableCard({
    super.key,
    required this.child,
    this.target,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: color,
      child: InkWell(
        onTap: target,
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}
