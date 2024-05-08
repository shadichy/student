import 'package:flutter/material.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class SettingsQuickActionPage extends StatefulWidget {
  final String listId;
  const SettingsQuickActionPage(this.listId, {super.key});

  @override
  State<SettingsQuickActionPage> createState() =>
      _SettingsQuickActionPageState();
}

class _SettingsQuickActionPageState extends State<SettingsQuickActionPage> {
  @override
  Widget build(BuildContext context) {
    return const SettingsBase(
      label: "About",
      children: [],
    );
  }
}
