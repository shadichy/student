import 'package:flutter/material.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/timetable/nextup_class.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/section_label.dart';

class TimetableNextupClassWidget extends StatefulWidget {
  final TimetableData timetableData;
  const TimetableNextupClassWidget(this.timetableData, {super.key});

  @override
  State<TimetableNextupClassWidget> createState() =>
      _TimetableNextupClassWidgetState();
}

class _TimetableNextupClassWidgetState
    extends State<TimetableNextupClassWidget> {
  List<TimetableNextupClassCard> classStamps = [
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.1',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.2',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.3',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.4',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.5',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.6',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.7',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.8',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.9',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
    TimetableNextupClassCard(
      classId: 'NNLAPTRINH.8.10',
      classDesc: 'Ngôn ngữ lập trình',
      teacher: 'Nguyễn Huyền Châu',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      room: 'A709',
    ),
  ];

  int index = 0;

  void changeClass(int nextClass) {
    if (nextClass < 0) nextClass = 0;
    if (nextClass >= classStamps.length) nextClass = classStamps.length - 1;
    setState(() {
      index = nextClass;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SectionLabel(
          "Môn học tiếp theo",
          Option(Icons.arrow_forward, "", () {}),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: colorScheme.onTertiaryContainer,
        ),
        classStamps[index],
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 32, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconOption(
                Option(
                  Icons.keyboard_double_arrow_left,
                  "",
                  () => changeClass(0),
                ),
                iconSize: 28,
                padding: const EdgeInsets.all(4),
                backgroundColor: colorScheme.tertiaryContainer,
                iconColor: colorScheme.onTertiaryContainer,
              ),
              IconOption(
                Option(
                  Icons.keyboard_arrow_left,
                  "",
                  () => changeClass(index - 1),
                ),
                iconSize: 28,
                padding: const EdgeInsets.all(4),
                backgroundColor: colorScheme.tertiaryContainer,
                iconColor: colorScheme.onTertiaryContainer,
              ),
              Expanded(
                child: Text(
                  "${classStamps.length - 1 - index} classes left",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colorScheme.onTertiaryContainer),
                ),
              ),
              IconOption(
                Option(
                  Icons.keyboard_arrow_right,
                  "",
                  () => changeClass(index + 1),
                ),
                iconSize: 28,
                padding: const EdgeInsets.all(4),
                backgroundColor: colorScheme.tertiaryContainer,
                iconColor: colorScheme.onTertiaryContainer,
              ),
              IconOption(
                Option(
                  Icons.keyboard_double_arrow_right,
                  "",
                  () => changeClass(classStamps.length - 1),
                ),
                iconSize: 28,
                padding: const EdgeInsets.all(4),
                backgroundColor: colorScheme.tertiaryContainer,
                iconColor: colorScheme.onTertiaryContainer,
              ),
            ],
          ),
        ),
        // const SizedBox(height: 32),
      ],
    );
  }
}
