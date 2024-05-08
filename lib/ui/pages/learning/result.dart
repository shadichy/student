import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class LearningResultPage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.assignment);

  @override
  String get title => "Kết quả học tập";

  const LearningResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
