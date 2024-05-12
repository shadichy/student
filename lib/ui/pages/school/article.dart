import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/ui/components/navigator/navigator.dart';

class SchoolArticlePage extends StatelessWidget implements TypicalPage {
  final String url;
  const SchoolArticlePage(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  Icon get icon => const Icon(Symbols.article);

  @override
  String get title => "Article of $url";
}
