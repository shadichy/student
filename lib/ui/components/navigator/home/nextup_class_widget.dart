import 'package:flutter/material.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/interpolator.dart';
import 'package:student/ui/components/navigator/home/nextup_class.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/section_label.dart';
import 'package:student/ui/components/navigator/nextup_class.dart';

class HomeNextupClassWidget extends StatefulWidget {
  final TimetableData timetableData;
  const HomeNextupClassWidget(this.timetableData, {super.key});

  @override
  State<HomeNextupClassWidget> createState() => _HomeNextupClassWidgetState();
}

class _HomeNextupClassWidgetState extends State<HomeNextupClassWidget> {
  List<NextupClassView> classStamps = [
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    NextupClassView(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    List<Widget> content = Interpolator<Widget>([
      classStamps.map((c) => HomeNextupClassCard(c)).toList(),
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.done,
            color: colorScheme.onSurface,
            size: 32,
          ),
        ),
      ]
    ]).output;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(
            "Next-up classes",
            Option(Icons.arrow_forward, "", () {}),
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: colorScheme.onSurface,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
