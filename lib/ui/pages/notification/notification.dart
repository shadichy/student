import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class NotificationPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.notifications);

  @override
  String get title => "Thông báo";

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<MapEntry<IconData, void Function()>> actions = ({
      Symbols.mark_email_read: () {},
      Symbols.clear_all: () {},
    }).entries.toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          widget.title,
          style: textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        actions: List.generate(actions.length, (_) {
          return [
            IconButton(
              onPressed: actions[_].value,
              icon: Icon(
                actions[_].key,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const VerticalDivider(
              width: 8,
              color: Colors.transparent,
            ),
          ];
        }).fold<List<Widget>>([], (p, n) => p + n),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
