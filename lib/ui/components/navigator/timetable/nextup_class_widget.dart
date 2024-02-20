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
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      TimetableNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      TimetableNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      TimetableNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      TimetableNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      TimetableNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      TimetableNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      TimetableNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
      TimetableNextupClassCard(
        classId: 'NNLAPTRINH.8.1',
        classDesc: 'Ngôn ngữ lập trình',
        teacher: 'Nguyễn Huyền Châu',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        room: 'A709',
      ),
    ];
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
        classStamps[0],
        Padding(
          padding: const EdgeInsets.only(top: 8,bottom: 32,left: 8, right: 8),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconOption(
                Option(Icons.keyboard_double_arrow_left, "", () {}),
                iconSize: 28,
                padding: const EdgeInsets.all(4),
                backgroundColor: colorScheme.tertiaryContainer,
                iconColor: colorScheme.onTertiaryContainer,
              ),
              IconOption(
                Option(Icons.keyboard_arrow_left, "", () {}),
                iconSize: 28,
                padding: const EdgeInsets.all(4),
                backgroundColor: colorScheme.tertiaryContainer,
                iconColor: colorScheme.onTertiaryContainer,
              ),
              Expanded(
                child: Text(
                  "1${classStamps.length -1} classes left",
                  style: TextStyle(color: colorScheme.onTertiaryContainer),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconOption(
                Option(Icons.keyboard_arrow_right, "", () {}),
                iconSize: 28,
                padding: const EdgeInsets.all(4),
                backgroundColor: colorScheme.tertiaryContainer,
                iconColor: colorScheme.onTertiaryContainer,
              ),
              IconOption(
                Option(Icons.keyboard_double_arrow_right, "", () {}),
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
