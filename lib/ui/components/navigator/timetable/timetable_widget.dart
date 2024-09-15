import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/databases/hive.dart';
// import 'package:student/core/semester/functions.dart';
import 'package:student/core/routing.dart';
import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/misc/misc_functions.dart';
// import 'package:student/misc/misc_variables.dart';
import 'package:student/ui/components/navigator/clickable_card.dart';
import 'package:student/ui/components/pages/learning/timetable.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/section_label.dart';

class TimetableWidget extends StatefulWidget {
  const TimetableWidget({super.key});

  @override
  State<TimetableWidget> createState() => _TimetableWidgetState();
}

class _TimetableWidgetState extends State<TimetableWidget> {
  WeekTimetable week = Storage().thisWeek;

  void changeWeek(DateTime startDate) {
    setState(() {
      week = Storage().getWeek(startDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    TimetableBox currentWeekView = TimetableBox(week);

    DateTime firstDoW = currentWeekView.firstWeekday;
    DateTime lastDoW = currentWeekView.lastWeekday;

    String dateFormat(DateTime date) {
      return MiscFns.timeFormat(date, format: "dd/MM");
    }

    Widget topBar = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Symbols.keyboard_arrow_left),
            onPressed: () => changeWeek(
              week.startDate.subtract(const Duration(days: 7)),
            ),
            iconSize: 28,
            padding: const EdgeInsets.all(4),
            // backgroundColor: colorScheme.primaryContainer,
            color: colorScheme.onPrimaryContainer,
          ),
          Expanded(
            child: Text(
              "${dateFormat(firstDoW)} - ${dateFormat(lastDoW)}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Symbols.keyboard_arrow_right),
            onPressed: () => changeWeek(
              week.startDate.add(const Duration(days: 7)),
            ),
            iconSize: 28,
            padding: const EdgeInsets.all(4),
            // backgroundColor: colorScheme.primaryContainer,
            color: colorScheme.onPrimaryContainer,
          ),
        ],
      ),
      // Center(
      //   child: Text(
      //     "Week ${1}",
      //     style: TextStyle(
      //       color: colorScheme.onPrimaryContainer,
      //       fontSize: 18,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
    );

    Widget bottomBar = Container(
      width: MediaQuery.of(context).size.width,
      height: 64,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      // child:
    );

    Widget mainContent = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .75,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: colorScheme.outlineVariant,
        ),
      ),
      child: currentWeekView,
    );

    // Widget detailPane = Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         "Definitions by colors: ",
    //         style: TextStyle(
    //           color: colorScheme.onPrimaryContainer,
    //           fontWeight: FontWeight.bold,
    //           fontSize: 16,
    //         ),
    //       ),
    //       ...widget.timetableData.classes
    //           .asMap()
    //           .map<int, Widget>(
    //             (key, value) => MapEntry(key, colorDef(key, value)),
    //           )
    //           .values
    //     ],
    //   ),
    // );

    // Widget trailingButton = Padding(
    //   padding: const EdgeInsets.only(bottom: 16, right: 12),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       TextButton(
    //         onPressed: () {},
    //         style: TextButton.styleFrom(
    //           shape: const RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(12)),
    //           ),
    //           backgroundColor: colorScheme.secondary,
    //           padding: const EdgeInsets.all(12),
    //         ),
    //         child: Text(
    //           "More...",
    //           style: TextStyle(
    //             color: colorScheme.onSecondary,
    //             fontWeight: FontWeight.bold,
    //             fontSize: 16,
    //           ),
    //           textAlign: TextAlign.end,
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Column(
      children: [
        SectionLabel(
          "Thời khoá biểu",
          icon: const Icon(Symbols.arrow_forward),
          target: () => Routing.goto(context, Routing.timetable),
          fontWeight: FontWeight.bold,
          textStyle: textTheme.titleMedium,
          color: colorScheme.onSurface,
        ),
        ClickableCard(
          target: () => Options.timetable.target(context),
          variant: CardVariant.outlined,
          color: Colors.transparent,
          child: Column(children: [
            topBar,
            mainContent,
            bottomBar,
            // detailPane,
            // trailingButton,
          ]),
        ),
      ],
    );
  }
}
