import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/pages/settings/components.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class SettingsAboutPage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.bookmark);

  @override
  String get title => "About";

  const SettingsAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsBase(
      label: "About",
      children: [],
    );
  }
}
