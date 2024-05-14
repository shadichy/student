import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/ui/components/navigator/navigator.dart';

class SchoolNewPapersPage extends StatelessWidget implements TypicalPage {
  const SchoolNewPapersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  Icon get icon => const Icon(Symbols.news);

  @override
  String get title => "Latest of TLU";
}
