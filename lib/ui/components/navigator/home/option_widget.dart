import 'package:flutter/material.dart';
import 'package:student/ui/components/interpolator.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class OptionIconWidgets extends StatefulWidget {
  final List<Option> options;
  const OptionIconWidgets(this.options, {super.key});

  @override
  State<OptionIconWidgets> createState() => _OptionIconWidgetsState();
}

class _OptionIconWidgetsState extends State<OptionIconWidgets> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    List<Widget> content = Interpolator([
      widget.options
          .map(
            (Option e) => IconOption(
              e,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              iconColor: colorScheme.onPrimaryContainer,
              backgroundColor: colorScheme.primaryContainer,
            ),
          )
          .toList(),
      [
        IconOption(
          Options.add("", (BuildContext context) {}),
          padding: const EdgeInsets.all(8),
          iconColor: colorScheme.onPrimaryContainer,
          backgroundColor: colorScheme.surface,
        )
      ]
    ]).output;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: content,
        ),
      ),
    );
  }
}
