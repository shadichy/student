import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class InfoMajorPage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.architecture);

  @override
  String get title => "Chuyên ngành đào tạo";

  const InfoMajorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
