import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/home/glance_widget.dart';
import 'package:student/ui/components/navigator/home/notification_widget.dart';
import 'package:student/ui/components/navigator/home/topbar_widget.dart';
import 'package:student/ui/components/navigator/home/upcoming_event_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/navigator/quick_navigators.dart';
import 'package:student/ui/components/with_appbar.dart';

class HomePage extends StatefulWidget implements TypicalPage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  Icon get icon => const Icon(Symbols.home);

  @override
  String get title => "Home";
}

class _HomePageState extends State<HomePage> {
  Iterable<Notif> _notif = [];

  bool get hasNotif => _notif.isNotEmpty;

  @override
  void initState() {
    super.initState();

    Storage().awaitNotificationInitialized().then((_) {
      setState(() {
        _notif = Storage().notifications.where((e) => !e.read).take(4);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return WithAppbar(
      height: 80,
      appBar: const HomeTopBar(),
      body: [
        const HomeGlance(),
        if (hasNotif) HomeNotifWidget(_notif.toList()),
        HomeNextupClassWidget(SampleTimetableData.from2dList([])),
        OptionLabelWidgets(widget.title),
        MWds.divider(16),
        Text(
          "You've reached the end\nHave a nice day!",
          maxLines: 2,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        MWds.divider(16),
      ],
    );
  }
}
