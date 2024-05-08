import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class InfoStudentDecisionsPage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.person_pin_circle);

  @override
  String get title => "Quyết định sinh viên";

  const InfoStudentDecisionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
