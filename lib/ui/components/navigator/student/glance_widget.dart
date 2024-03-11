import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class StudentGlance extends StatefulWidget {
  final Image userPicture;
  final String userFullName;
  final String userCode;
  const StudentGlance({
    super.key,
    required this.userCode,
    required this.userFullName,
    required this.userPicture,
  });

  @override
  State<StudentGlance> createState() => _StudentGlanceState();
}

class _StudentGlanceState extends State<StudentGlance> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        // color: colorScheme.primaryContainer,
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.onPrimaryContainer,
              width: 2.0,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            height: 160,
            width: 160,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: widget.userPicture,
          ),
        ),
        const Divider(
          color: Colors.transparent,
          height: 8,
        ),
        Text(
          widget.userFullName,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const Divider(
          color: Colors.transparent,
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "#",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                fontSize: 24,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              widget.userCode,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                fontSize: 18,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
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
      ]),
    );
  }
}
