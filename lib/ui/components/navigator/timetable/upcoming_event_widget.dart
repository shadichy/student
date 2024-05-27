import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/core/routing.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/navigator/timetable/upcoming_event.dart';
import 'package:student/ui/components/section_label.dart';

class TimetableUpcomingWidget extends StatefulWidget {
  final Iterable<UpcomingEvent> classStamps;
  const TimetableUpcomingWidget(this.classStamps, {super.key});

  @override
  State<TimetableUpcomingWidget> createState() =>
      _TimetableUpcomingWidgetState();
}

class _TimetableUpcomingWidgetState extends State<TimetableUpcomingWidget> {
  late final Iterable<UpcomingEvent> classStamps;

  int index = 0;

  @override
  void initState() {
    super.initState();
    classStamps = widget.classStamps;
  }

  // void _changeClass(int nextClass) {
  //   if (nextClass < 0) nextClass = 0;
  //   if (nextClass >= classStamps.length) nextClass = classStamps.length - 1;
  //   setState(() {
  //     index = nextClass;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SectionLabel(
          "Môn học tiếp theo",
          icon: const Icon(Symbols.arrow_forward),
          target: () => Routing.goto(context, Routing.upcoming),
          fontWeight: FontWeight.bold,
          textStyle: textTheme.titleMedium,
          color: colorScheme.onSurface,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          itemBuilder: ((context, index) {
            return TimetableUpcomingCardAlt(classStamps.elementAt(index));
          }),
          separatorBuilder: ((context, index) => MWds.divider(8)),
          itemCount: classStamps.length > 2 ? 2 : classStamps.length,
          // scrollDirection: Axis.vertical,
          shrinkWrap: true,
        ),
        // TimetableUpcomingCard(classStamps[index]),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        //   child: Row(
        //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       IconOption(
        //         Option(
        //           const Icon(Symbols.keyboard_double_arrow_left),
        //           "",
        //           (context) => changeClass(0),
        //         ),
        //         iconSize: 28,
        //         margin: const EdgeInsets.only(right: 8),
        //         padding: const EdgeInsets.all(4),
        //         backgroundColor: colorScheme.primaryContainer,
        //         iconColor: colorScheme.onPrimaryContainer,
        //       ),
        //       IconOption(
        //         Option(
        //           const Icon(Symbols.keyboard_arrow_left),
        //           "",
        //           (context) => changeClass(index - 1),
        //         ),
        //         iconSize: 28,
        //         margin: const EdgeInsets.only(right: 8),
        //         padding: const EdgeInsets.all(4),
        //         backgroundColor: colorScheme.primaryContainer,
        //         iconColor: colorScheme.onPrimaryContainer,
        //       ),
        //       Expanded(
        //         child: Center(
        //           child: Text(
        //             "${classStamps.length - 1 - index} classes left",
        //             overflow: TextOverflow.ellipsis,
        //             style: TextStyle(color: colorScheme.onPrimaryContainer),
        //           ),
        //         ),
        //       ),
        //       IconOption(
        //         Option(
        //           const Icon(Symbols.keyboard_arrow_right),
        //           "",
        //           (context) => changeClass(index + 1),
        //         ),
        //         iconSize: 28,
        //         margin: const EdgeInsets.only(left: 8),
        //         padding: const EdgeInsets.all(4),
        //         backgroundColor: colorScheme.primaryContainer,
        //         iconColor: colorScheme.onPrimaryContainer,
        //       ),
        //       IconOption(
        //         Option(
        //           const Icon(Symbols.keyboard_double_arrow_right),
        //           "",
        //           (context) => changeClass(classStamps.length - 1),
        //         ),
        //         iconSize: 28,
        //         margin: const EdgeInsets.only(left: 8),
        //         padding: const EdgeInsets.all(4),
        //         backgroundColor: colorScheme.primaryContainer,
        //         iconColor: colorScheme.onPrimaryContainer,
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
