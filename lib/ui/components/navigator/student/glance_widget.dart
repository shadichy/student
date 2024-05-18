import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/connect.dart';

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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 72,
              height: 72,
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.onPrimaryContainer,
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: widget.studentPicture.image,
              ),
            ),
            title: Text(
              widget.studentFullName,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleLarge!.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "# ${widget.studentCode}",
              style: textTheme.titleMedium!.apply(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          MWds.divider(8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Table(
              columnWidths: const {0: FixedColumnWidth(80)},
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
                      fontWeight: FontWeight.bold,
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
          MWds.divider(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...[
                'notif',
                'student',
                'help',
              ].map(
                (opt) => IconOption(
                  opt,
                  // onPressed: () => Routing.goto(context, opt),
                  // margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(16),
                  color: colorScheme.onPrimary,
                  backgroundColor: colorScheme.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Symbols.logout),
                onPressed: () => Server.kill(),
                // margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                color: colorScheme.onSecondary,
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                ),
                iconSize: 24,
              ),
            ],
          ),
          // SizedBox(
          //   width: 160,
          //   child: TextOption(
          //     Option(
          //       const Icon(Symbols.logout),
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
