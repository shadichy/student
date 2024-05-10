import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/section_label.dart';

class OptionLabelWidgets extends StatelessWidget {
  // final List<Option> options;
  final String id;
  final List<String> routes;
  final String headingLabel;
  const OptionLabelWidgets(
    this.id,
    this.routes, {
    super.key,
    this.headingLabel = "Quick actions",
  });

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
      ...List.generate(routes.length, (index) {
        TypicalPage t = Routing.getRoute(routes[index])!;
        return SubPage(
          label: t.title,
          target: t,
          icon: Icon(t.icon.icon, size: 28),
          minVerticalPadding: 16,
        );
      }),
      // SizedBox(
      //   width: 220,
      //   child: TextOption(
      //     Options.add((BuildContext context) {}),
      //     label: "Thêm shortcut",
      //     margin: const EdgeInsets.symmetric(vertical: 8),
      //     padding: const EdgeInsets.symmetric(horizontal: 16),
      //     color: colorScheme.onPrimaryContainer,
      //     backgroundColor: colorScheme.primaryContainer,
      //     fontWeight: FontWeight.w700,
      //     textAlign: TextAlign.center,
      //     iconSize: 24,
      //     fontSize: 12,
      //     borderRadius: const BorderRadius.all(Radius.circular(30)),
      //     dense: true,
      //   ),
      // ),
      const Divider(
        height: 8,
        color: Colors.transparent,
      ),
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
      const Divider(
        height: 8,
        color: Colors.transparent,
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
