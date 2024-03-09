import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  final Widget child;
  final void Function()? target;
  const ClickableCard({
    super.key,
    required this.child,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: InkWell(
        onTap: target,
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}
