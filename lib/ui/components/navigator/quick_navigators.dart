import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/routing.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/section_label.dart';

class OptionLabelWidgets extends StatefulWidget {
  // final List<Option> options;
  final String id;
  final String headingLabel;

  const OptionLabelWidgets(
    this.id, {
    super.key,
    this.headingLabel = "Quick actions",
  });

  @override
  State<OptionLabelWidgets> createState() => _OptionLabelWidgetsState();
}

class _OptionLabelWidgetsState extends State<OptionLabelWidgets> {
  late List<String> _routes;

  void setRoute() {
    _routes = Storage().fetch<List>("opts.${widget.id}")!.cast();
    // Must be defined in the default configuration;
  }

  @override
  void initState() {
    setRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<Widget> content = [
      SectionLabel(
        widget.headingLabel,
        icon: const Icon(Symbols.arrow_forward),
        target: () => Routing.goto(
          context,
          Routing.quick_action_edit(widget.id),
        ).then((_) => setState(setRoute)),
        // fontWeight: FontWeight.w300,
        textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        color: colorScheme.onPrimaryContainer,
      ),
      ...List.generate(_routes.length, (index) {
        TypicalPage t = Routing.getRoute(_routes[index])!;
        return SubPage(
          label: t.title,
          target: t,
          icon: Icon(t.icon.icon, size: 28),
          minVerticalPadding: 16,
        );
      }),
      MWds.divider(8),
      InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: () => Routing.goto(
          context,
          Routing.quick_action_edit(widget.id),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: colorScheme.primaryContainer,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.add,
                size: 24,
                color: colorScheme.onPrimaryContainer,
              ),
              MWds.vDivider(),
              Text(
                "Add shortcut",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
      MWds.divider(8),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(children: content),
    );
  }
}
