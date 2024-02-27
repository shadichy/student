import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student/core/functions.dart';
import 'package:student/core/generator.dart';
import 'package:student/core/presets.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_variables.dart';
import 'package:student/ui/components/interpolator.dart';

// class ColorTimetable extends BaseTimetable {
//   ColorTimetable({required super.classes});
// }

class TimetableBox extends StatelessWidget {
  final BaseTimetable timetable;
  const TimetableBox(this.timetable, {super.key});
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    List<List<Widget>> structured = List<List<Widget>>.generate(
      classTimeStamps.length,
      (int _) => List<Widget>.generate(7, (int _) => const SizedBox.shrink()),
    );

    Widget textBox(
      String text, {
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 2),
    }) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      );
    }

    timetable.classes.asMap().forEach((int d, SubjectClass c) {
      c.intMatrix.asMap().forEach((int i, int m) {
        for (int j = 0; j < classTimeStamps.length; j++) {
          if (m & (1 << j) == 0) continue;
          structured[j][i] = TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: InkWell(
              onTap: () {},
              child: Container(color: m3PrimeColor[d]),
            ),
          );
        }
      });
    });

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(52),
        8: FixedColumnWidth(52),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        width: 1,
        color: colorScheme.primary.withOpacity(0.05),
      ),
      children: [
        TableRow(
          children: Interpolator<Widget>([
            [const SizedBox.shrink()],
            (MediaQuery.of(context).size.width > 480
                    ? [
                        "Sun",
                        "Mon",
                        "Tue",
                        "Wed",
                        "Thu",
                        "Fri",
                        "Sat",
                      ]
                    : [
                        "S",
                        "M",
                        "T",
                        "W",
                        "T",
                        "F",
                        "S",
                      ])
                .map<Widget>((String s) => textBox(s))
                .toList(),
            [const SizedBox.shrink()],
          ]).output,
        ),
        for (int i = 0; i < classTimeStamps.length; i++)
          TableRow(
            children: Interpolator<Widget>([
              [
                textBox(
                  timeFormat(
                    date.add(Duration(seconds: classTimeStamps[i][0])),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                )
              ],
              structured[i],
              [
                textBox(
                  timeFormat(
                    date.add(Duration(seconds: classTimeStamps[i][1])),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                )
              ],
            ]).output,
          ),
      ],
    );
  }
}
