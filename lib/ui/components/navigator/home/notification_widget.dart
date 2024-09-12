import 'package:flutter/material.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/ui/components/navigator/home/notification.dart';

class HomeNotifWidget extends StatefulWidget {
  final List<NotificationInstance> notifications;
  const HomeNotifWidget(this.notifications, {super.key});

  @override
  State<HomeNotifWidget> createState() => _HomeNotifWidgetState();
}

class _HomeNotifWidgetState extends State<HomeNotifWidget> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // print(widget.notifications);
    return Container(
      margin: const EdgeInsets.all(16).copyWith(bottom: 0),
      // padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.05),
        // shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: NotifExpandableBox(widget.notifications),
    );
  }
}
