import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/routing.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class SearchPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.search);

  @override
  String get title => "Tìm kiếm";

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    String hintText = "Type anything to start...";

    List<MapEntry<IconData, void Function()>> actions = ({
      Symbols.filter_alt: () {},
      Symbols.search: () => Routing.goto(context, Routing.search_result(query)),
    }).entries.toList();
    return Scaffold(
      appBar: AppBar(
        // preferredSize: const Size.fromHeight(64),
        // elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        flexibleSpace: TextField(
          textAlignVertical: TextAlignVertical.center,
          autofocus: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
            hintText: hintText,
            prefixIcon: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Symbols.arrow_back, size: 28),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(actions.length, (_) {
                return [
                  IconButton(
                    onPressed: actions[_].value,
                    icon: Icon(
                      actions[_].key,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const VerticalDivider(
                    width: 4,
                    color: Colors.transparent,
                  ),
                ];
              }).fold<List<Widget>>([], (p, n) => p + n),
            ),
          ),
          onChanged: (_) => setState(() => query = _),
        ),
      ),
      // body: ListView.builder(),
    );
  }
}
