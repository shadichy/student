import 'package:flutter/material.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/section_label.dart';

class OptionLabelWidgets extends StatefulWidget {
  // final List<Option> options;
  final List<String> routes;
  final String headingLabel;
  const OptionLabelWidgets(
    this.routes, {
    super.key,
    this.headingLabel = "Quick actions",
  });

  @override
  State<OptionLabelWidgets> createState() => _OptionLabelWidgetsState();
}

class _OptionLabelWidgetsState extends State<OptionLabelWidgets> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<Widget> content = [
      SectionLabel(
        widget.headingLabel,
        Options.add((BuildContext context) {}),
        // fontWeight: FontWeight.w300,
        textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        color: colorScheme.onPrimaryContainer,
      ),
      ...List.generate(widget.routes.length, (index) {
        TypicalPage t = Routing.getRoute(widget.routes[index])!;
        return SubPage(
          label: t.title,
          target: t,
          icon: Icon(t.icon.icon, size: 28),
          minVerticalPadding: 16,
        );
      }),
      SizedBox(
        width: 220,
        child: TextOption(
          Options.add((BuildContext context) {}),
          label: "Thêm shortcut",
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: colorScheme.onPrimaryContainer,
          backgroundColor: colorScheme.primaryContainer,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          iconSize: 24,
          fontSize: 12,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          dense: true,
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: content,
      ),
    );
  }
}
