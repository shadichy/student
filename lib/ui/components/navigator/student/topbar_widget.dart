import 'package:flutter/material.dart';
import 'package:student/core/routing.dart';

class StudentTopBar extends StatelessWidget {
  const StudentTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Routing.themes,
        Routing.notif,
      ].map((o) {
        return IconButton(
          icon: o.icon,
          onPressed: () => Routing.goto(context, o),
          color: colorScheme.onPrimaryContainer,
          iconSize: 24,
          // padding: const EdgeInsets.all(8),
          // backgroundColor: colorScheme.primaryContainer,
        );
      }).toList(),
    );
  }
}
