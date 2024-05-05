import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/core/generator/generator.dart';
import 'package:student/core/presets.dart';
import 'package:student/misc/misc_functions.dart';
// import 'package:student/misc/misc_variables.dart';
// import 'package:student/ui/components/navigator/upcoming_event.dart';
// import 'package:student/ui/components/navigator/upcoming_event_preview.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import 'package:bitcount/bitcount.dart';
// import 'package:web/web.dart';

// class ColorTimetable extends BaseTimetable {
//   ColorTimetable({required super.classes});
// }

double _cellSize = 128;
double _headerCellSize = 72;

// class _ColorCell {
//   final Color color;
//   final CourseTimeStamp? stamp;
//   final Widget? child;
//   const _ColorCell({required this.color, this.stamp, this.child});
// }

// class _CellState {
//   final EdgeInsets margin;
//   final BorderRadius? radius;
//   const _CellState({required this.margin, this.radius});
// }

// List<_CellState> _cellSates = [
//   _CellState(
//     margin: const EdgeInsets.all(12).copyWith(bottom: 0),
//     radius: const BorderRadius.only(
//       topLeft: Radius.circular(12),
//       topRight: Radius.circular(12),
//     ),
//   ),
//   const _CellState(margin: EdgeInsets.symmetric(horizontal: 12)),
//   _CellState(
//     margin: const EdgeInsets.all(12).copyWith(top: 0),
//     radius: const BorderRadius.only(
//       bottomLeft: Radius.circular(12),
//       bottomRight: Radius.circular(12),
//     ),
//   ),
// ];

// class TimetableBox extends StatelessWidget {
//   final SampleTimetable timetable;
//   const TimetableBox(this.timetable, {super.key});
//   @override
//   Widget build(BuildContext context) {
//     ColorScheme colorScheme = Theme.of(context).colorScheme;
//     TextTheme textTheme = Theme.of(context).textTheme;
//     DateTime now = DateTime.now();
//     DateTime date = DateTime(now.year, now.month, now.day);

//     List<List<_ColorCell?>> colorMap = List<List<_ColorCell?>>.generate(
//       7,
//       (int _) => List<_ColorCell?>.generate(
//         classTimeStamps.length,
//         (int _) => null,
//       ),
//     );

//     // Widget textBox(
//     //   String text, {
//     //   EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 2),
//     //   FontWeight fontWeight = FontWeight.w600,
//     // }) {
//     //   return Center(
//     //       child: Padding(
//     //     padding: padding,
//     //     child: Text(
//     //       text,
//     //       style: TextStyle(
//     //         fontSize: 12,
//     //         color: colorScheme.onPrimaryContainer,
//     //         fontWeight: fontWeight,
//     //       ),
//     //     ),
//     //   ));
//     // }

//     // Widget dayTextBox(DateTime time) {
//     //   return textBox(
//     //     MiscFns.timeFormat(
//     //       time,
//     //       format: "dd/MM",
//     //     ),
//     //     fontWeight: FontWeight.w800,
//     //   );
//     // }

//     // Widget hmTextBox(int seconds) {
//     //   return textBox(
//     //     MiscFns.timeFormat(
//     //       date.add(Duration(seconds: seconds)),
//     //     ),
//     //     padding: const EdgeInsets.symmetric(
//     //       horizontal: 4,
//     //       vertical: 2,
//     //     ),
//     //   );
//     // }

//     // String dayOfWeek = "SMTWTFS";
//     List<String> shortDayOfWeek = [
//       'Sun',
//       'Mon',
//       'Tue',
//       'Wed',
//       'Thu',
//       'Fri',
//       'Sat'
//     ];

//     // Widget colorBox({Color? color, Widget? child, CourseTimeStamp? stamp}) {
//     //   return TableCell(
//     //     verticalAlignment: TableCellVerticalAlignment.fill,
//     //     child: InkWell(
//     //       onTap: (stamp is CourseTimeStamp)
//     //           ? () {
//     //               showBottomSheet(
//     //                 context: context,
//     //                 builder: ((BuildContext context) {
//     //                   return NextupClassSheet(NextupClassView.fromStamp(stamp));
//     //                 }),
//     //               );
//     //             }
//     //           : null,
//     //       child: Container(
//     //         alignment: Alignment.center,
//     //         color: color,
//     //         child: child,
//     //       ),
//     //     ),
//     //   );
//     // }

//     timetable.classes.asMap().forEach((int d, SubjectCourse c) {
//       for (int i = 0; i < 7; i++) {
//         for (int j = 0; j < classTimeStamps.length; j++) {
//           if ((c.intCourse >> (classTimeStamps.length * i + j)) & BigInt.one ==
//               BigInt.zero) continue;

//           CourseTimeStamp timestamp = c.timestamp.firstWhere(
//             (CourseTimeStamp s) =>
//                 c.intCourse &
//                     (BigInt.from(s.intStamp) << classTimeStamps.length * i) !=
//                 BigInt.zero,
//           );
//           colorMap[i][j] = _ColorCell(
//             color: M3SeededColor.colors[d],
//             stamp: timestamp,
//             child: Text(
//               timestamp.room,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: colorScheme.onPrimary,
//                 fontSize: 12,
//               ),
//             ),
//           );

//           // else {
//           //   if (i == now.weekday &&
//           //       colorMap[i][j].color == Colors.transparent) {
//           //     colorMap[i][j] = ColorCell(
//           //       color: colorScheme.primary.withOpacity(0.05),
//           //     );
//           //   }
//           // }
//         }
//       }
//     });

//     // List<TableRow> genTable = [
//     //   TableRow(
//     //     children: [
//     //       dayTextBox(now.subtract(Duration(days: now.weekday))),
//     //       ...dayOfWeek.characters.indexed.map<Widget>((d) {
//     //         Widget base = textBox(d.$2);
//     //         if (d.$1 != now.weekday) return base;
//     //         return colorBox(
//     //           color: colorScheme.primary.withOpacity(0.05),
//     //           child: base,
//     //         );
//     //       }),
//     //       dayTextBox(now.add(Duration(days: 6 - now.weekday))),
//     //     ],
//     //   ),
//     //   ...List<TableRow>.generate(classTimeStamps.length, (int j) {
//     //     return TableRow(
//     //       children: [
//     //         hmTextBox(classTimeStamps[j][0]),
//     //         ...List<Widget>.generate(7, (int i) {
//     //           return colorBox(
//     //             color: colorMap[i][j]!.color,
//     //             stamp: colorMap[i][j]!.stamp,
//     //             child: colorMap[i][j]!.child,
//     //           );
//     //         }),
//     //         hmTextBox(classTimeStamps[j][1])
//     //       ],
//     //     );
//     //   }),
//     // ];

//     Span builder(b) {
//       return TableSpan(
//         extent: FixedTableSpanExtent(b == 0 ? _headerCellSize : _cellSize),
//         backgroundDecoration: TableSpanDecoration(
//           // color: column == 0 ? Colors.yellow.withOpacity(0.3) : null,
//           border: TableSpanBorder(
//             trailing: BorderSide(
//               color: colorScheme.outlineVariant,
//             ),
//           ),
//         ),
//       );
//     }

//     DateTime firstDoW = now.subtract(Duration(days: now.weekday));
//     int week = 1;

//     Widget headRowBuilder(String firstLine, String lastLine) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             firstLine,
//             style: textTheme.labelLarge!.copyWith(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             lastLine,
//             style: textTheme.titleLarge,
//           )
//         ],
//       );
//     }

//     List<Widget> headRow = <Widget>[
//       headRowBuilder("Week", "$week"),
//       ...shortDayOfWeek.asMap().map((i, d) {
//         Widget content = headRowBuilder(
//           shortDayOfWeek[i],
//           MiscFns.timeFormat(
//             firstDoW.add(Duration(days: i)),
//             format: "d",
//           ),
//         );
//         return MapEntry(
//           i,
//           i != now.weekday
//               ? content
//               : Container(
//                   color: colorScheme.primary.withOpacity(0.05),
//                   child: content,
//                 ),
//         );
//       }).values,
//     ];

//     Widget firstColBuilder(int stamp) {
//       return Container(
//         alignment: Alignment.topCenter,
//         padding: const EdgeInsets.only(top: 16),
//         child: Text(
//           "${MiscFns.timeFormat(
//             date.add(
//               Duration(seconds: classTimeStamps[stamp - 1][0]),
//             ),
//           )}\nC$stamp",
//           style: textTheme.labelLarge!.copyWith(
//             fontWeight: FontWeight.w500,
//           ),
//           maxLines: 2,
//         ),
//       );
//     }

//     List<List<Widget>> tableContent = List.generate(7, (i) {
//       Color? color;
//       if (i == now.weekday) color = colorScheme.primary.withOpacity(0.05);
//       return List.generate(classTimeStamps.length, (j) {
//         Widget? child;
//         if (colorMap[i][j]?.stamp is CourseTimeStamp) {
//           _CellState state;
//           Widget? cellChild;
//           if (j == 0 || colorMap[i][j]?.stamp != colorMap[i][j - 1]?.stamp) {
//             state = _cellSates[0];
//             cellChild = Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${colorMap[i][j]?.stamp?.room}\n${colorMap[i][j]?.stamp?.courseID}",
//                     maxLines: 3,
//                     overflow: TextOverflow.clip,
//                     style: textTheme.labelLarge!.copyWith(
//                       fontWeight: FontWeight.w500,
//                     ),
//                   )
//                 ],
//               ),
//             );
//           } else if (j == classTimeStamps.length - 1 ||
//               colorMap[i][j]?.stamp != colorMap[i][j + 1]?.stamp) {
//             state = _cellSates[2];
//           } else {
//             state = _cellSates[1];
//           }
//           child = InkWell(
//             onTap: () {
//               // showBottomSheet(
//               //   context: context,
//               //   builder: ((BuildContext context) {
//               //     return NextupClassSheet(widget.nextupClass);
//               //   }),
//               // );
//             },
//             child: Container(
//               margin: state.margin,
//               decoration: BoxDecoration(
//                 borderRadius: state.radius,
//                 color: colorScheme.primaryContainer,
//               ),
//               child: cellChild,
//             ),
//           );
//         }
//         return Container(
//           color: color,
//           child: child,
//         );
//       });
//     });

//     for (int i = 0; i < 7; i++) {
//       for (int j = 0; j < classTimeStamps.length; j++) {}
//     }

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * .75,
//       decoration: BoxDecoration(
//           border: Border.all(
//         width: 1,
//         color: colorScheme.outlineVariant,
//       )),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           TableView.builder(
//               pinnedColumnCount: 1,
//               pinnedRowCount: 1,
//               columnCount: 8,
//               rowCount: classTimeStamps.length + 1,
//               columnBuilder: builder,
//               rowBuilder: builder,
//               cellBuilder: (BuildContext context, TableVicinity vicinity) {
//                 return TableViewCell(
//                   child: vicinity.row == 0
//                       ? headRow[vicinity.column]
//                       : vicinity.column == 0
//                           ? firstColBuilder(vicinity.row)
//                           : tableContent[vicinity.column - 1][vicinity.row - 1],
//                 );
//               }),
//           Positioned(
//             top: _headerCellSize + _cellSize,
//             left: _headerCellSize + _cellSize,
//             height: 4,
//             width: _cellSize,
//             child: Divider(
//               color: colorScheme.onPrimaryContainer,
//               height: 4,
//               thickness: 4,
//             ),
//           )
//         ],
//       ),
//     );
//     // return Table(
//     //   columnWidths: const {
//     //     0: FixedColumnWidth(52),
//     //     8: FixedColumnWidth(52),
//     //   },
//     //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//     //   border: TableBorder.all(
//     //     width: 1,
//     //     color: colorScheme.primary.withOpacity(0.05),
//     //   ),
//     //   children: genTable,
//     // );
//   }
// }

class TimetableBoxAlt extends StatelessWidget {
  final SampleTimetable timetable;
  const TimetableBoxAlt(this.timetable, {super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    List<String> shortDayOfWeek = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ];

    DateTime firstDoW = date.subtract(Duration(days: now.weekday));
    int week = 1;

    Span builder(double cellSize) {
      return TableSpan(
        extent: FixedTableSpanExtent(cellSize),
        backgroundDecoration: TableSpanDecoration(
          // color: column == 0 ? Colors.yellow.withOpacity(0.3) : null,
          border: TableSpanBorder(
            trailing: BorderSide(
              color: colorScheme.outlineVariant,
            ),
          ),
        ),
      );
    }

    Widget headRowBuilder(String firstLine, String lastLine) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            firstLine,
            style: textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            lastLine,
            style: textTheme.titleLarge,
          )
        ],
      );
    }

    List<TableViewCell> headRow = <Widget>[
      headRowBuilder("Week", "$week"),
      ...shortDayOfWeek.asMap().map((i, d) {
        Widget content = headRowBuilder(
          shortDayOfWeek[i],
          MiscFns.timeFormat(
            firstDoW.add(Duration(days: i)),
            format: "d",
          ),
        );
        return MapEntry(
          i,
          i != now.weekday
              ? content
              : Container(
                  color: colorScheme.primary.withOpacity(0.05),
                  child: content,
                ),
        );
      }).values,
    ].map((e) => TableViewCell(child: e)).toList();

    Widget firstColBuilder(int stamp) {
      return Positioned(
        height: _cellSize,
        width: _headerCellSize,
        top: _cellSize * stamp,
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            "${MiscFns.timeFormat(
              date.add(
                Duration(seconds: classTimeStamps[stamp][0]),
              ),
            )}\nC${stamp + 1}",
            style: textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
          ),
        ),
      );
    }

    TableViewCell inColBuilder(List<Widget> children, index) {
      Widget content = Stack(
        children: [
          ...children,
          ...List.generate(
            classTimeStamps.length - 1,
            (index) => Positioned(
              width: _cellSize,
              height: 1,
              top: _cellSize * (index + 1) - 1,
              child: Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outlineVariant,
              ),
            ),
          ),
          if (index == now.weekday)
            Positioned(
              top: _cellSize *
                      (() {
                        int current = now.difference(date).inSeconds;
                        int startAt = 0;
                        while (current > classTimeStamps[startAt][0] &&
                            startAt < classTimeStamps.length - 1) {
                          startAt++;
                        }
                        startAt--;
                        double diff = (current - classTimeStamps[startAt][0]) /
                            (classTimeStamps[startAt][1] -
                                classTimeStamps[startAt][0]);
                        return diff + startAt;
                      })() -
                  2,
              height: 4,
              width: _cellSize,
              child: Divider(
                color: colorScheme.onPrimaryContainer,
                height: 4,
                thickness: 4,
              ),
            ),
        ],
      );
      return TableViewCell(
        child: index != now.weekday
            ? content
            : Container(
                color: colorScheme.primary.withOpacity(0.05),
                width: _cellSize,
                // height: _cellSize * classTimeStamps.length,
                child: content,
              ),
      );
    }

    TableViewCell firstCols = inColBuilder(
      List.generate(classTimeStamps.length, firstColBuilder),
      7,
    );
    // print(
    // "$_cellSize,${classTimeStamps[classTimeStamps.length - 1][1] - classTimeStamps[0][0]},${now.difference(date).inSeconds},${now.difference(date).inSeconds - classTimeStamps[0][0]}, ${((now.difference(date).inSeconds - classTimeStamps[0][0]) / (classTimeStamps[classTimeStamps.length - 1][1] - classTimeStamps[0][0]))},${_cellSize * classTimeStamps.length * ((now.difference(date).inSeconds - classTimeStamps[0][0]) / (classTimeStamps[classTimeStamps.length - 1][1] - classTimeStamps[0][0]))}");

    List<List<Widget>> timetableMap = List.generate(7, (index) => []);

    for (SubjectCourse c in timetable.classes) {
      for (CourseTimeStamp s in c.timestamp) {
        int classStartsAt = 0;
        while (s.intStamp & (1 << classStartsAt) == 0) {
          classStartsAt++;
        }
        int classLength = s.intStamp.bitCount();
        timetableMap[s.dayOfWeek].add(Positioned(
          width: _cellSize,
          height: _cellSize * classLength,
          top: _cellSize * classStartsAt,
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {},
              radius: 12,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${s.room}\n${c.courseID}",
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                      style: textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
      }
    }

    // print(timetableMap);

    List<TableViewCell> restCols =
        List.generate(7, (i) => inColBuilder(timetableMap[i], i));

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .75,
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: colorScheme.outlineVariant,
      )),
      child: TableView.list(
        pinnedColumnCount: 1,
        pinnedRowCount: 1,
        columnBuilder: (c) => builder(
          c == 0 ? _headerCellSize : _cellSize,
        ),
        rowBuilder: (r) => builder(
          r == 0 ? _headerCellSize : _cellSize * classTimeStamps.length,
        ),
        cells: [
          headRow,
          [firstCols, ...restCols],
          // ...firstCols.map((e) => [e, ...restCols]),
        ],
      ),
    );
  }
}
