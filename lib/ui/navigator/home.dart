import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/misc/misc_widget.dart';
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
  Iterable<NotificationInstance> _notifications = [];

  bool get hasNotifications => _notifications.isNotEmpty;

  void setNotifications(_) {
    if (!mounted) return;
    setState(() {
      _notifications = Storage().notifications.where((e) => !e.isRead).take(4);
    });
  }

  @override
  void initState() {
    super.initState();

    if (!mounted) return;
    Storage().awaitNotificationInitialized().then(setNotifications);
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
        const NextupEventWidget(),
        // HomeNextupClassWidget(SampleTimetableData.from2dList([])),
        // if (hasNotif) HomeNotifWidget(_notif.toList()),
        AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: hasNotifications
              ? HomeNotifWidget(_notifications.toList())
              : const SizedBox(),
        ),
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
