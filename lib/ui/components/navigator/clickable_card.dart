import 'package:flutter/material.dart';

enum CardVariant { elevated, filled, outlined }

class ClickableCard extends StatelessWidget {
  final Widget child;
  final void Function()? target;
  final Color? color;
  final CardVariant variant;
  const ClickableCard({
    super.key,
    required this.child,
    this.target,
    this.color,
    this.variant = CardVariant.filled,
  });

  @override
  Widget build(BuildContext context) {
    Widget Function(Widget) cardVariant;
    switch (variant) {
      case CardVariant.elevated:
        cardVariant = (child) => Card(
              color: color,
              child: child,
            );
      case CardVariant.outlined:
        cardVariant = (child) => Card.outlined(
              color: color,
              child: child,
            );
      default:
        cardVariant = (child) => Card.filled(
              color: color,
              child: child,
            );
    }
    return cardVariant(InkWell(
      onTap: target,
      borderRadius: BorderRadius.circular(16),
      child: child,
    ));
  }
}
