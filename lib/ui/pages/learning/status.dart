import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class LearningStatusPage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.browse_activity);

  @override
  String get title => "Tiến trình học tập";

  const LearningStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
