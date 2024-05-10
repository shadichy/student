import 'package:flutter/material.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class SettingsQuickActionPage extends StatefulWidget implements TypicalPage {
  final String listId;
  const SettingsQuickActionPage(this.listId, {super.key});

  @override
  State<SettingsQuickActionPage> createState() =>
      _SettingsQuickActionPageState();

  @override
  // TODO: implement icon
  Icon get icon => throw UnimplementedError();

  @override
  // TODO: implement title
  String get title => throw UnimplementedError();
}

class _SettingsQuickActionPageState extends State<SettingsQuickActionPage> {
  @override
  Widget build(BuildContext context) {
    return const SettingsBase(
      label: "Edit",
      children: [],
    );
  }
}
