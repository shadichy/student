import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class InfoEduProgramPage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.book);

  @override
  String get title => "Chương trình đào tạo";

  const InfoEduProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
