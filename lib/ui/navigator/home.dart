import 'package:flutter/material.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/home/glance_widget.dart';
import 'package:student/ui/components/navigator/home/nextup_class_widget.dart';
import 'package:student/ui/components/navigator/home/notification.dart';
import 'package:student/ui/components/navigator/home/notification_widget.dart';
import 'package:student/ui/components/navigator/home/option_widget.dart';
import 'package:student/ui/components/navigator/home/topbar_widget.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/navigator/quick_navigations.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<Notif> notifs = [
    Notif("title", content: "content"),
  ];

  late final bool hasNotif = notifs.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Widget endText(String text, EdgeInsetsGeometry padding) => Padding(
          padding: padding,
          child: Text(
            text,
            maxLines: 2,
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
        );
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 72, 0, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Glance(
                    Image.network(
                      "https://picsum.photos/250?image=9",
                      fit: BoxFit.cover,
                    ),
                    "Shadichy",
                  ),
                  OptionIconWidgets([
                    Options.settings,
                    Options.user,
                    Options.timetable,
                    Options.help,
                    Options.search,
                  ]),
                  if (hasNotif) const HomeNotifWidget([]),
                  HomeNextupClassWidget(TimetableData.from2dList([])),
                  OptionLabelWidgets([
                    Options.settings,
                    Options.study_program,
                    Options.study_results,
                    Options.student_finance,
                    Options.help,
                  ]),
                  endText(
                    "You've reached the end",
                    const EdgeInsets.only(top: 16),
                  ),
                  endText(
                    "Have a nice day!",
                    const EdgeInsets.only(bottom: 16),
                  ),
                ],
              ),
            ),
          ),
          const HomeTopBar(),
        ],
      ),
    );
  }
}
