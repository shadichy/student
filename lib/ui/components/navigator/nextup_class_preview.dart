import 'package:flutter/material.dart';
// import 'package:sheet/sheet.dart';
import 'package:student/ui/components/navigator/nextup_class.dart';

class NextupClassSheet extends StatefulWidget {
  final NextupClassView nextupClass;
  const NextupClassSheet(this.nextupClass, {super.key});

  @override
  State<NextupClassSheet> createState() => _NextupClassSheetState();
}

class _NextupClassSheetState extends State<NextupClassSheet> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // return Sheet(
    //   resizable: true,
    //   initialExtent: 200,
    //   minExtent: 100,
    //   maxExtent: 400,
    //   child: Container(),
    // );
    return Container();
  }
}
