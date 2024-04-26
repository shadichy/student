import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class StudentGlance extends StatefulWidget {
  final Image studentPicture;
  final String studentFullName;
  final String studentCode; // or studentID
  final String studentSchool;
  final String studentMajor;
  final String studentClass;
  final String studentGPA;
  final int studentCred;
  const StudentGlance({
    super.key,
    required this.studentCode,
    required this.studentFullName,
    required this.studentPicture,
    required this.studentSchool,
    required this.studentMajor,
    required this.studentClass,
    required this.studentGPA,
    required this.studentCred,
  });

  @override
  State<StudentGlance> createState() => _StudentGlanceState();
}

class _StudentGlanceState extends State<StudentGlance> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        //   border: Border.all(width: 1, color: colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        // color: colorScheme.primaryContainer,
        color: colorScheme.primaryContainer,
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.onPrimaryContainer,
                  width: 2.0,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                height: 72,
                width: 72,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: widget.studentPicture,
              ),
            ),
            const VerticalDivider(
              color: Colors.transparent,
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentFullName,
                  style: textTheme.titleLarge!.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "# ${widget.studentCode}",
                  style: textTheme.titleMedium!.apply(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            )
          ]),
          const Divider(
            color: Colors.transparent,
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Table(
              columnWidths: const {0: FixedColumnWidth(60)},
              children: [
                MapEntry("Major", widget.studentMajor),
                MapEntry("Class", widget.studentClass),
                MapEntry("Credit", "${widget.studentCred}/144"),
                MapEntry("GPA", widget.studentGPA),
              ].map((item) {
                return TableRow(children: [
                  Text(
                    "${item.key}: ",
                    style: textTheme.bodyLarge!.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item.value,
                    style: textTheme.bodyLarge!.apply(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  )
                ]);
              }).toList(),
            ),
          ),
          const Divider(
            color: Colors.transparent,
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...[
                Options.notifications,
                Options.user,
                Options.help,
              ].map(
                (Option opt) => IconOption(
                  opt,
                  // margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(8),
                  iconColor: colorScheme.onPrimary,
                  backgroundColor: colorScheme.primary,
                ),
              ),
              IconOption(
                Option(
                  const Icon(Icons.logout_outlined),
                  "Logout",
                  (BuildContext context) {},
                ),
                // margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(12),
                iconColor: colorScheme.onSecondary,
                backgroundColor: colorScheme.secondary,
                iconSize: 24,
              ),
            ],
          ),
          // SizedBox(
          //   width: 160,
          //   child: TextOption(
          //     Option(
          //       const Icon(Icons.logout_outlined),
          //       "Logout",
          //       (BuildContext context) {},
          //     ),
          //     margin: const EdgeInsets.symmetric(vertical: 8),
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     color: colorScheme.onTertiaryContainer,
          //     backgroundColor: colorScheme.tertiaryContainer,
          //     fontWeight: FontWeight.w700,
          //     textAlign: TextAlign.center,
          //     iconSize: 24,
          //     fontSize: 12,
          //     borderRadius: const BorderRadius.all(Radius.circular(30)),
          //     dense: true,
          //   ),
          // )
        ],
      ),
    );
  }
}
