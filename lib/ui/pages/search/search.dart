import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class SearchPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.search);

  @override
  String get title => "Tìm kiếm";

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body: ListView.builder(),
    );
  }
}
