import 'package:flutter/material.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/home/nextup_class.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/section_label.dart';

class HomeNextupClassWidget extends StatefulWidget {
  final TimetableData timetableData;
  const HomeNextupClassWidget(this.timetableData, {super.key});

  @override
  State<HomeNextupClassWidget> createState() => _HomeNextupClassWidgetState();
}

class _HomeNextupClassWidgetState extends State<HomeNextupClassWidget> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    List<Widget> classStamps = [
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      HomeNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          Icons.done,
          color: colorScheme.onBackground,
          size: 32,
        ),
      ),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SectionLabel(
          "Next-up classes",
          Option(Icons.arrow_forward, "", () {}),
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: classStamps,
            ),
          ),
        ),
      ],
    );
  }
}
