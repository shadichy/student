import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/core/configs.dart';
import 'package:student/core/routing.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/section_label.dart';

class OptionLabelWidgets extends StatelessWidget {
  // final List<Option> options;
  final String id;
  final List<String> _routes;
  final String headingLabel;
  OptionLabelWidgets(
    this.id, {
    super.key,
    this.headingLabel = "Quick actions",
  }) : _routes = MiscFns.listType<String>(
          AppConfig().getConfig<List>("opts.$id")!,
        );

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<Widget> content = [
      SectionLabel(
        headingLabel,
        icon: const Icon(Symbols.arrow_forward),
        target: () => Routing.goto(context, Routing.quick_action_edit(id)),
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
        onTap: () => Routing.goto(context, Routing.quick_action_edit(id)),
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
              const VerticalDivider(
                width: 8,
                color: Colors.transparent,
              ),
              Text(
                "Add shortcut",
                style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      MWds.divider(8),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: content,
      ),
    );
  }
}
