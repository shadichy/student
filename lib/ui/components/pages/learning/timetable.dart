import 'package:flutter/material.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/pages/event_preview.dart';
// import 'package:student/misc/misc_variables.dart';
// import 'package:student/ui/components/navigator/upcoming_event.dart';
// import 'package:student/ui/components/navigator/upcoming_event_preview.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
// import 'package:web/web.dart';

// class ColorTimetable extends BaseTimetable {
//   ColorTimetable({required super.classes});
// }

double _cellSize = 128;
double _headerCellSize = 72;

class TimetableBox extends StatelessWidget {
  final WeekTimetable timetable;
  final DateTime firstWeekday;
  final DateTime lastWeekday;
  final int currentWeek;
  TimetableBox(this.timetable, {super.key})
      : firstWeekday = timetable.startDate,
        lastWeekday = timetable.startDate.add(const Duration(days: 6)),
        currentWeek = timetable.weekNo ?? 0;

  Iterable<T> _remapDiff<T>(Iterable<T> input, [int diff = 0]) {
    if (diff == 0) return input;
    return [...input.skip(diff), ...input.take(diff)];
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final int weekdayStart = Storage().weekdayStart;
    int weekday = (now.weekday - weekdayStart + 7) % 7;
    List<String> shortDayOfWeek = _remapDiff([
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ], weekdayStart)
        .toList();

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

    List<Widget> headRow = [
      headRowBuilder("Week", "${timetable.weekNo! + 1}"),
      ...shortDayOfWeek.asMap().map((i, d) {
        Widget content = headRowBuilder(
          shortDayOfWeek[i],
          MiscFns.timeFormat(
            firstWeekday.add(Duration(days: i)),
            format: "d",
          ),
        );
        return MapEntry(
          i,
          i != weekday
              ? content
              : Container(
                  color: colorScheme.primary.withOpacity(0.05),
                  child: content,
                ),
        );
      }).values,
    ];

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
                Duration(seconds: SPBasics().classTimestamps[stamp][0]),
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

    TableViewCell inColBuilder(Iterable<Widget> children, int index) {
      Widget content = Stack(
        children: [
          ...children,
          ...List.generate(
            SPBasics().classTimestamps.length - 1,
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
          if (index == weekday)
            Positioned(
              top: _cellSize *
                      (() {
                        int current = now.difference(date).inSeconds;
                        if (current >
                            SPBasics().classTimestamps[
                                SPBasics().classTimestamps.length - 1][1]) {
                          return SPBasics().classTimestamps.length;
                        }
                        int startAt = 0;
                        while (
                            current > SPBasics().classTimestamps[startAt][0]) {
                          startAt++;
                          if (startAt == SPBasics().classTimestamps.length) {
                            break;
                          }
                        }
                        if (startAt > 0) startAt--;
                        double diff = (current >
                                    SPBasics().classTimestamps[startAt][1] &&
                                current <
                                    SPBasics().classTimestamps[startAt][0])
                            ? 1
                            : ((current -
                                    SPBasics().classTimestamps[startAt][0]) /
                                (SPBasics().classTimestamps[startAt][1] -
                                    SPBasics().classTimestamps[startAt][0]));
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
        child: index != weekday
            ? content
            : Container(
                color: colorScheme.primary.withOpacity(0.05),
                width: _cellSize,
                // height: _cellSize * SPBasics().classTimestamps.length,
                child: content,
              ),
      );
    }

    TableViewCell firstCols = inColBuilder(
      List.generate(SPBasics().classTimestamps.length, firstColBuilder),
      7,
    );
    // print(
    // "$_cellSize,${SPBasics().classTimestamps[SPBasics().classTimestamps.length - 1][1] - SPBasics().classTimestamps[0][0]},${now.difference(date).inSeconds},${now.difference(date).inSeconds - SPBasics().classTimestamps[0][0]}, ${((now.difference(date).inSeconds - SPBasics().classTimestamps[0][0]) / (SPBasics().classTimestamps[SPBasics().classTimestamps.length - 1][1] - SPBasics().classTimestamps[0][0]))},${_cellSize * SPBasics().classTimestamps.length * ((now.difference(date).inSeconds - SPBasics().classTimestamps[0][0]) / (SPBasics().classTimestamps[SPBasics().classTimestamps.length - 1][1] - SPBasics().classTimestamps[0][0]))}");

    List<List<Widget>> timetableMap = List.generate(7, (index) => []);

    // for (var c in timetable.classes) {
    for (var s in timetable.timestamps) {
      if (s.intStamp == 0) continue;
      int classStartsAt = s.startStamp;
      int classLength = s.stampLength;
      timetableMap[(s.dayOfWeek - weekdayStart + 7) % 7].add(Positioned(
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
            onTap: () async => await showEventPreview(
                context: context,
                eventData: s is CourseTimestamp
                    ? NextupClassView(s)
                    : UpcomingEvent.fromTimestamp(s)),
            radius: 12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s is CourseTimestamp
                        ? "${s.room}\n${s.courseID}"
                        : s.eventName,
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
    // }

    // print(timetableMap);

    Iterable<TableViewCell> restCols =
        List.generate(7, (i) => inColBuilder(timetableMap[i], i));

    return TableView.list(
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      columnBuilder: (c) => builder(
        c == 0 ? _headerCellSize : _cellSize,
      ),
      rowBuilder: (r) => builder(
        r == 0
            ? _headerCellSize
            : _cellSize * SPBasics().classTimestamps.length,
      ),
      cells: [
        List.generate(headRow.length, (c) => TableViewCell(child: headRow[c])),
        [firstCols, ...restCols],
        // ...firstCols.map((e) => [e, ...restCols]),
      ],
    );
  }
}
