import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/core/routing.dart';

class NotifExpand extends StatefulWidget {
  final NotificationInstance notification;
  const NotifExpand(this.notification, {super.key});

  @override
  State<NotifExpand> createState() => _NotifExpandState();
}

class _NotifExpandState extends State<NotifExpand> {
  bool isExpanded = false;

  void changeState() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(bodyColor: colorScheme.onPrimaryContainer);

    TextStyle titleStyle = textTheme.bodyLarge!.copyWith(
      // 16
      fontWeight: FontWeight.bold,
    );
    TextStyle contentStyle = textTheme.bodyMedium!; // 14
    TextStyle noteStyle = textTheme.bodySmall!.copyWith(
      // 12
      fontWeight: FontWeight.w200,
    );
    TextStyle linkStyle = contentStyle.copyWith(
      fontWeight: FontWeight.w600,
    );

    String timeNote = (widget.notification.uploadDate is DateTime)
        ? (<String>(Duration? d) {
            return "${d!.inHours > 0 ? "${d.inHours}h" : ""}${d.inMinutes}m";
          })(widget.notification.uploadDate?.difference(DateTime.now()))
        : "now";

    Widget textBox(String text, {TextStyle? style, int? maxLines}) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      child: InkWell(
        // onTap: isExpanded ? widget.notification.target : null,
        child: Row(
          crossAxisAlignment:
              isExpanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    crossFadeState: isExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 200),
                    firstChild: textBox(
                      timeNote,
                      style: noteStyle,
                    ),
                    secondChild: const SizedBox(),
                  ),
                  Row(
                    children: [
                      textBox(
                        widget.notification.title,
                        style: titleStyle,
                      ),
                      AnimatedCrossFade(
                        crossFadeState: !isExpanded
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 200),
                        firstChild: textBox(
                          (" \u2022 $timeNote"),
                          style: noteStyle,
                        ),
                        secondChild: const SizedBox(),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 240),
                    child: textBox(
                      widget.notification.content,
                      style: contentStyle,
                      maxLines: isExpanded ? 2 : 1,
                    ),
                  ),
                  AnimatedCrossFade(
                    crossFadeState: isExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 200),
                    firstChild: InkWell(
                      // onTap: ()=>Routing.goto(context, Routing.notifPage(widget.notification).target),
                      child: textBox(
                        "More...",
                        style: linkStyle,
                      ),
                    ),
                    secondChild: const SizedBox(),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: IconButton(
                onPressed: changeState,
                icon: Icon(
                    isExpanded
                        ? Symbols.keyboard_arrow_up
                        : Symbols.keyboard_arrow_down,
                    size: 16,
                    color: colorScheme.onPrimaryContainer),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primary.withOpacity(0.05),
                ),
                splashRadius: 2,
                iconSize: 16,
                padding: EdgeInsets.zero,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NotifExpandableBox extends StatefulWidget {
  final List<NotificationInstance> notifications;
  const NotifExpandableBox(this.notifications, {super.key});

  @override
  State<NotifExpandableBox> createState() => _NotifExpandableBoxState();
}

class _NotifExpandableBoxState extends State<NotifExpandableBox> {
  late List<NotificationInstance> notifications = widget.notifications;
  bool isExpanded = false;

  // void add(Notif value) {
  //   setState(() {
  //     notifications.insert(0, value);
  //   });
  // }

  void pop(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void changeState() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(bodyColor: colorScheme.onPrimaryContainer);
    // notifications = widget.notifications;
    // print(widget.notifications);
    Widget titlePreview(NotificationInstance notif) {
      return Padding(
        padding: const EdgeInsets.only(left: 32, right: 24),
        child: Row(
          children: [
            Text(
              "${notif.title}  ",
              style: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              child: Text(
                notif.content,
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      child: InkWell(
        onTap: () => Routing.goto(context, Routing.notif),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary.withOpacity(0.05),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Symbols.notifications,
                      color: colorScheme.onPrimaryContainer,
                      size: 16,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Latest Notifications",
                        style: textTheme.labelLarge,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      onPressed: changeState,
                      icon: Icon(
                          isExpanded
                              ? Symbols.keyboard_arrow_up
                              : Symbols.keyboard_arrow_down,
                          size: 16,
                          color: colorScheme.onPrimaryContainer),
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.primary.withOpacity(0.05),
                      ),
                      splashRadius: 1,
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                    ),
                  )
                ],
              ),
              const Divider(
                color: Colors.transparent,
                height: 4,
              ),
              Column(
                children: List.generate(notifications.length, (n) {
                  return Dismissible(
                    key: Key(notifications[n].title),
                    onDismissed: (_) => setState(() {
                      notifications.removeAt(n);
                    }),
                    child: AnimatedCrossFade(
                      firstChild: NotifExpand(notifications[n]),
                      secondChild: titlePreview(notifications[n]),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 200),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
