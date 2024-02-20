import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student/core/functions.dart';
import 'package:student/core/generator.dart';
import 'package:student/core/presets.dart';

// class ColorTimetable extends BaseTimetable {
//   ColorTimetable({required super.classes});
// }

class TimetableBox extends StatelessWidget {
  final BaseTimetable timetable;
  final Map<String, Color> colorData = {};
  TimetableBox(this.timetable, {super.key});
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    List<List<Widget>> structured = List<List<Widget>>.filled(
      classTimeStamps.length,
      List<Widget>.filled(7, const SizedBox.shrink()),
    );
    for (SubjectClass c in timetable.classes) {
      if (!colorData.containsKey(c.classID)) {
        colorData[c.classID] =
            Colors.primaries[Random().nextInt(Colors.primaries.length)];
      }
      for (int i = 0; i < c.intMatrix.length; i++) {
        List<String> refs = c.intMatrix[i].toRadixString(2).characters.toList();
        for (int j = 0; j < refs.length; j++) {
          if (refs[j] != '1') continue;
          structured[i][j] = Container(color: colorData[c.classID]);
        }
      }
    }
    return Table(
      columnWidths: const {0: FixedColumnWidth(48)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (int i = 0; i < classTimeStamps.length; i++)
          TableRow(
            children: <Widget>[
                  Text(
                    DateFormat.Hm("VN").format(
                        date.add(Duration(seconds: classTimeStamps[i][0]))),
                  )
                ] +
                structured[i],
          )
      ],
    );
  }
}
