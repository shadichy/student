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
    return const Placeholder();
  }
}
