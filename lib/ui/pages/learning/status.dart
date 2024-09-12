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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Symbols.more_horiz),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(),
      ),
    );
  }
}
