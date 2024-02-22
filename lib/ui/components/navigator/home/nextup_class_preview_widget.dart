import 'package:flutter/material.dart';
// import 'package:sheet/sheet.dart';
import 'package:student/ui/components/navigator/nextup_class.dart';

class HomeNextupClassSheet extends StatefulWidget {
  final NextupClassView nextupClass;
  const HomeNextupClassSheet(this.nextupClass, {super.key});

  @override
  State<HomeNextupClassSheet> createState() => _HomeNextupClassSheetState();
}

class _HomeNextupClassSheetState extends State<HomeNextupClassSheet> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // return Sheet(
    //   child: Container(),
    // );
    return Container();
  }
}
