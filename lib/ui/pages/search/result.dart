import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/ui/components/navigator/navigator.dart';

class SearchResultPage extends StatelessWidget implements TypicalPage {
  final String query;
  const SearchResultPage(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  Icon get icon => const Icon(Symbols.search);

  @override
  String get title => "Result of $query";
}
