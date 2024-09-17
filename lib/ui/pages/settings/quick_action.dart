import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/pages/settings/searchable_selector_dialog.dart';

class SettingsQuickActionPage extends StatefulWidget implements TypicalPage {
  final String id;

  const SettingsQuickActionPage(this.id, {super.key});

  @override
  State<SettingsQuickActionPage> createState() =>
      _SettingsQuickActionPageState();

  @override
  Icon get icon => throw UnimplementedError();

  @override
  String get title => throw UnimplementedError();
}

class _SettingsQuickActionPageState extends State<SettingsQuickActionPage> {
  late final List<String> routes =
      Storage().fetch<List>("opts.${widget.id}")!.cast();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    Storage().put("opts.${widget.id}", routes);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return SettingsBase(
      label: "Edit",
      children: [
        ReorderableListView(
          shrinkWrap: true,
          children: List.generate(routes.length, (i) {
            TypicalPage t = Routing.getRoute(routes[i])!;
            return ListTile(
              key: Key('$i'),
              minVerticalPadding: 16,
              title: Text(t.title),
              leading: SizedBox(
                width: 80,
                child: Row(children: [
                  const Icon(Symbols.reorder, size: 28),
                  Icon(t.icon.icon, size: 28),
                ]),
              ),
              trailing: IconButton(
                onPressed: () => setState(() => routes.removeAt(i)),
                icon: Icon(Symbols.clear, color: colorScheme.error),
              ),
            );
          }),
          onReorder: (p, n) {
            if (p < n) n -= 1;
            final item = routes.removeAt(p);
            routes.insert(n, item);
            setState(() {});
          },
        ),
        TextButton.icon(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (_) => SearchableSelectorDialog(
              items: Routing.allRoutes.keys.toList(),
              itemBuilder: (_, i) {
                TypicalPage t = Routing.getRoute(i)!;
                return SubPage(
                  label: t.title,
                  icon: Icon(t.icon.icon, size: 28),
                );
              },
              searchMethod: (query, _) {
                String k = query.toLowerCase();
                return routes
                    .where((i) => i.toLowerCase().contains(k))
                    .toList();
              },
            ),
          ).then((route) {
            if (route == null) return;
            setState(() => routes.add(route));
          }),
          icon: Icon(
            Symbols.add,
            color: colorScheme.secondary,
          ),
          label: Text(
            "Add item",
            style: textTheme.labelMedium?.apply(color: colorScheme.secondary),
          ),
          style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
        )
      ],
    );
  }
}
