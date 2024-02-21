import 'package:flutter/material.dart';
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

    List<IconOption> configIconOptions = widget.options
        .map((Option e) => IconOption(
              e,
              padding: const EdgeInsets.all(8),
              iconColor: colorScheme.onTertiaryContainer,
              backgroundColor: colorScheme.tertiaryContainer,
            ))
        .toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: configIconOptions +
              [
                IconOption(
                  Options.add("", () {}),
                  padding: const EdgeInsets.all(8),
                  iconColor: colorScheme.onTertiaryContainer,
                  backgroundColor: colorScheme.background,
                )
              ],
        ),
      ),
    );
  }
}
