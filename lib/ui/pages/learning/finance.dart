import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class LearningFinance extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.credit_card);

  @override
  String get title => "Tài chính sinh viên";

  const LearningFinance({super.key});

  @override
  State<LearningFinance> createState() => _LearningFinanceState();
}

class _LearningFinanceState extends State<LearningFinance> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
