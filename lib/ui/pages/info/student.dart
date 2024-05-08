import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/pages/settings/components.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class InfoStudentPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.manage_accounts);

  @override
  String get title => "Thông tin sinh viên";

  const InfoStudentPage({super.key});

  @override
  State<InfoStudentPage> createState() => _InfoStudentPageState();
}

class _InfoStudentPageState extends State<InfoStudentPage> {
  @override
  Widget build(BuildContext context) {
    return const SettingsBase(label: "Thông tin sinh viên", children: []);
  }
}
