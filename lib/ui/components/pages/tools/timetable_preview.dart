import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/core/generator/generator.dart';
import 'package:student/core/routing.dart';
import 'package:student/misc/iterable_extensions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/pages/learning/timetable.dart';

class TimetablePreview extends StatefulWidget {
  final SampleTimetable data;
  const TimetablePreview(this.data, {super.key});

  @override
  State<TimetablePreview> createState() => _TimetablePreviewState();
}

class _TimetablePreviewState extends State<TimetablePreview> {
  late final data = widget.data;

  Widget iconButton({
    required void Function()? onPressed,
    required Widget icon,
    ButtonStyle? style,
  }) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: icon,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(16),
      ).merge(style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ThemeData d = Theme.of(context);
    ColorScheme c = d.colorScheme;
    TextTheme t = d.textTheme;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: size.width,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Subjects",
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: c.primary,
                        ),
                      ),
                      MWds.divider(8),
                      ...data.courses.map<Widget>((course) {
                        return Text(
                            "\u2022 ${course.subjectID}: ${course.courseID}");
                      }).separatedBy(MWds.divider(8)),
                    ],
                  ),
                ),
              ),
              Column(children: [
                iconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.bookmark),
                ),
                MWds.divider(16),
                iconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.edit),
                ),
              ])
            ]),
            MWds.divider(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.arrow_back_ios),
                ),
                iconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.arrow_forward_ios),
                )
              ],
            ),
          ]),
        ),
        Expanded(
          child: InkWell(
            onTap: () => Routing.goto(
              context,
              Routing.generated_timetable_preview(data.timetable),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              color: c.surfaceContainerLowest,
              child: TimetableBox(data.timetable),
            ),
          ),
        )
      ]),
    );
  }
}
