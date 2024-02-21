import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/section_label.dart';

class OptionLabelWidgets extends StatefulWidget {
  final List<Option> options;
  const OptionLabelWidgets(this.options, {super.key});

  @override
  State<OptionLabelWidgets> createState() => _OptionLabelWidgetsState();
}

class _OptionLabelWidgetsState extends State<OptionLabelWidgets> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    List<TextOption> configLabelOptions = widget.options
        .map((Option e) => TextOption(
              e,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: colorScheme.onSecondaryContainer,
              backgroundColor: colorScheme.background,
              fontWeight: FontWeight.w700,
            ))
        .toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
            SectionLabel(
              "Quick actions",
              Options.add("", () {}),
              fontWeight: FontWeight.w900,
              fontSize: 20,
            )
          ] +
          configLabelOptions +
          [
            SizedBox(
              width: 220,
              child: TextOption(
                Options.add("Thêm shortcut", () {}),
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: colorScheme.onSecondaryContainer,
                backgroundColor: colorScheme.secondaryContainer,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                iconSize: 24,
                fontSize: 12,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                dense: true,
              ),
            )
          ],
    );
  }
}
