import 'package:bitcount/bitcount.dart';
import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/ui/components/pages/event_detail.dart';

import 'package:student/ui/components/navigator/navigator.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SubjectStampPage extends StatelessWidget implements TypicalPage {
  static List<String> shortDayOfWeek = const [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
  @override
  Icon get icon => const Icon(Symbols.event);

  @override
  String get title =>
      "${stamp.room} \u2022 ${shortDayOfWeek[stamp.dayOfWeek]} C${((){
        int classStartsAt = 0;
        while (stamp.intStamp & (1 << classStartsAt) == 0) {
          classStartsAt++;
        }
        int classLength = stamp.intStamp.bitCount();
        return "${classStartsAt+1}-${classStartsAt+classLength}";
      })()} ${stamp.courseID}${stamp.courseType == null ? "" : "_${stamp.courseType!.name}"}";

  final CourseTimeStamp stamp;
  const SubjectStampPage(this.stamp, {super.key});

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    return const EventPage(
      label: "Thông tin lớp học",
      title: "A709 \u2022 C3 \u2022 NNLAPTRINH.8.1_BT",
      children: [],
    );
  }
}
