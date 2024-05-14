import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/home/glance_widget.dart';
import 'package:student/ui/components/navigator/home/upcoming_event_widget.dart';
import 'package:student/ui/components/navigator/home/notification_widget.dart';
import 'package:student/ui/components/navigator/home/topbar_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/navigator/quick_navigators.dart';
import 'package:student/ui/components/with_appbar.dart';

class HomePage extends StatelessWidget implements TypicalPage {
  HomePage({super.key});

  final Iterable<Notif> _notif =
      NotificationsGet().notifications.where((e) => e.applied == false).take(4);

  late final bool hasNotif = _notif.isNotEmpty;

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
        OptionLabelWidgets(title),
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

  @override
  Icon get icon => const Icon(Symbols.home);

  @override
  String get title => "Home";
}
