import 'package:flutter/material.dart';
import 'package:student/core/functions.dart';
import 'package:student/core/generator.dart';
import 'package:student/core/presets.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_variables.dart';
import 'package:student/ui/components/navigator/nextup_class.dart';
import 'package:student/ui/components/navigator/nextup_class_preview.dart';
// import 'package:web/web.dart';

// class ColorTimetable extends BaseTimetable {
//   ColorTimetable({required super.classes});
// }

class ColorCell {
  final Color color;
  final CourseTimeStamp? stamp;
  const ColorCell({required this.color, this.stamp});
}

class TimetableBox extends StatelessWidget {
  final BaseTimetable timetable;
  const TimetableBox(this.timetable, {super.key});
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    List<List<ColorCell>> colorMap = List<List<ColorCell>>.generate(
      7,
      (int _) => List<ColorCell>.generate(
        classTimeStamps.length,
        (int _) => const ColorCell(
          color: Colors.transparent,
        ),
      ),
    );

    Widget textBox(
      String text, {
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 2),
      FontWeight fontWeight = FontWeight.w600,
    }) {
      return Center(
          child: Padding(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onPrimaryContainer,
            fontWeight: fontWeight,
          ),
        ),
      ));
    }

    Widget dayTextBox(DateTime time) {
      return textBox(
        timeFormat(
          time,
          format: "dd/MM",
        ),
        fontWeight: FontWeight.w800,
      );
    }

    Widget hmTextBox(int seconds) {
      return textBox(
        timeFormat(
          date.add(Duration(seconds: seconds)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
      );
    }

    String dayOfWeek = "SMTWTFS";

    Widget colorBox({Color? color, Widget? child, CourseTimeStamp? stamp}) {
      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: InkWell(
          onTap: (stamp is CourseTimeStamp)
              ? () {
                  showBottomSheet(
                    context: context,
                    builder: ((BuildContext context) {
                      return NextupClassSheet(NextupClassView.fromStamp(stamp));
                    }),
                  );
                }
              : null,
          child: Container(
            color: color,
            child: child,
          ),
        ),
      );
    }

    timetable.classes.asMap().forEach((int d, SubjectCourse c) {
      for (int i = 0; i < 7; i++) {
        for (int j = 0; j < classTimeStamps.length; j++) {
          if ((c.intCourse >> (classTimeStamps.length * i + j)) & BigInt.one !=
              BigInt.zero) {
            colorMap[i][j] = ColorCell(
              color: M3SeededColor.colors[d],
              stamp: c.timestamp[0],
            );
          } else if (i == now.weekday &&
              colorMap[i][j].color == Colors.transparent) {
            colorMap[i][j] = ColorCell(
              color: colorScheme.primary.withOpacity(0.05),
            );
          }
        }
      }
    });

    List<TableRow> genTable = [
      TableRow(
        children: [
          dayTextBox(now.subtract(Duration(days: now.weekday))),
          ...dayOfWeek.characters.indexed.map<Widget>((d) {
            Widget base = textBox(d.$2);
            if (d.$1 != now.weekday) return base;
            return colorBox(
              color: colorScheme.primary.withOpacity(0.05),
              child: base,
            );
          }),
          dayTextBox(now.add(Duration(days: 6 - now.weekday))),
        ],
      ),
      ...List<TableRow>.generate(classTimeStamps.length, (int j) {
        return TableRow(
          children: [
            hmTextBox(classTimeStamps[j][0]),
            ...List<Widget>.generate(7, (int i) {
              return colorBox(
                color: colorMap[i][j].color,
                stamp: colorMap[i][j].stamp,
              );
            }),
            hmTextBox(classTimeStamps[j][1])
          ],
        );
      }),
    ];

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
