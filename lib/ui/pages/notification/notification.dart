import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/routing.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/navigator/navigator.dart';

class NotificationPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.notifications);

  @override
  String get title => "Thông báo";

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // notif.applyDates!.length == 1
  // ? MiscFns.timeFormat(
  // notif.uploadDate!,
  // format: "HH:mm dd/MM/yyyy",
  // )
  //     : "${MiscFns.timeFormat(
  // notif.applyDates!.first,
  // format: "HH:mm dd/MM/yyyy",
  // )}- ${MiscFns.timeFormat(
  // notif.applyDates!.last,
  // format: "HH:mm dd/MM/yyyy",
  // )}"

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    // Widget separated(List<Widget> children) {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: List.generate(children.length * 2, (index) {
    //       return index % 2 == 0
    //           ? children[index ~/ 2]
    //           : Divider(
    //               height: 8,
    //               thickness: 1,
    //               indent: 32,
    //               endIndent: 32,
    //               color: colorScheme.outlineVariant,
    //             );
    //     }),
    //   );
    // }

    List<MapEntry<IconData, void Function()>> actions = ({
      Symbols.mark_email_read: () async {
        for (var n in Storage().notifications) {
          await n.read();
        }
        if (mounted) setState(() {});
      },
      Symbols.clear_all: () =>
          Storage().clearNotifications().then((_) => setState(() {})),
    }).entries.toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          widget.title,
          style: textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        actions: List.generate(actions.length, (i) {
          return [
            IconButton(
              onPressed: actions[i].value,
              icon: Icon(
                actions[i].key,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const VerticalDivider(
              width: 8,
              color: Colors.transparent,
            ),
          ];
        }).fold<List<Widget>>([], (p, n) => p + n),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: Storage().notifications.map((notification) {
          return GestureDetector(
            onTap: () => Routing.goto(
              context,
              Routing.notification_detail(notification),
            ).then((_) => setState(() {})),
            child: Container(
              color: notification.isRead
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        notification.uploadDate == null
                            ? "Recently"
                            : MiscFns.timeFormat(
                                notification.uploadDate!,
                                format: "HH:mm dd/MM/yyyy",
                              ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w300,
                                ),
                        maxLines: 3,
                      ),
                      Text(
                        notification.title,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        notification.content,
                        style: Theme.of(context).textTheme.labelLarge,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () =>
                            notification.read().then((_) => setState(() {})),
                        icon: Icon(
                          notification.isRead
                              ? Symbols.notifications_off
                              : Symbols.notifications_active,
                          color: notification.isRead
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                        ),
                      ),
                      // MWds.divider(8),
                      IconButton(
                        onPressed: () =>
                            notification.delete().then((_) => setState(() {})),
                        icon: Icon(
                          Symbols.delete,
                          color: notification.isRead
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }).toList()),
      ),
    );
  }
}
