import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:student/core/functions.dart';
import 'package:student/core/generator.dart';
import 'package:student/core/presets.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_variables.dart';
import 'package:student/ui/components/interpolator.dart';
// import 'package:web/web.dart';

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

    List<List<Color>> colorMap = List<List<Color>>.generate(
      7,
      (int _) => List<Color>.generate(
        classTimeStamps.length,
        (int _) => Colors.transparent,
      ),
    );

    Widget textBox(
      String text, {
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 2),
    }) {
      return Center(
        child: Padding(
          padding: padding,
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

    String dayOfWeek = "SMTWTFS";

    Widget colorBox({Color? color, Widget? child}) {
      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: Container(
          color: color,
          child: child,
        ),
      );
    }

    timetable.classes.asMap().forEach((int d, SubjectClass c) {
      c.intMatrix.asMap().forEach((int i, int m) {
        for (int j = 0; j < classTimeStamps.length; j++) {
          if (m & (1 << j) != 0) {
            colorMap[i][j] = m3PrimeColor[d];
            continue;
          }
          if (i == now.weekday) {
            colorMap[i][j] = colorScheme.primary.withOpacity(0.05);
          }
        }
      });
    });

    List<TableRow> genTable = Interpolator<TableRow>([
      [
        TableRow(
          children: Interpolator<Widget>([
            [
              textBox(timeFormat(
                now.subtract(Duration(days: now.weekday - 1)),
                format: "dd/MM",
              )),
            ],
            dayOfWeek.characters.indexed.map<Widget>((d) {
              Widget base = textBox(d.$2);
              if (d.$1 == now.weekday) {
                base = colorBox(
                  color: colorScheme.primary.withOpacity(0.05),
                  child: base,
                );
              }
              return base;
            }).toList(),
            [
              textBox(timeFormat(
                now.add(Duration(days: 7 - now.weekday)),
                format: "dd/MM",
              ))
            ],
          ]).output,
        )
      ],
      List<TableRow>.generate(classTimeStamps.length, (int j) {
        return TableRow(
          children: Interpolator<Widget>([
            [
              textBox(
                timeFormat(
                  date.add(Duration(seconds: classTimeStamps[j][0])),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
              )
            ],
            List<Widget>.generate(7, (int i) {
              return colorBox(color: colorMap[i][j]);
            }),
            [
              textBox(
                timeFormat(
                  date.add(Duration(seconds: classTimeStamps[j][1])),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
              )
            ],
          ]).output,
        );
      }),
    ]).output;

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
      children: genTable,
    );
  }
}
