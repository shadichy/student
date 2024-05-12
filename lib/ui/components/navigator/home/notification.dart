import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/notification/notification.dart';

class NotifExpand extends StatefulWidget {
  final Notif notification;
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
      duration: const Duration(milliseconds: 100),
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
                  if (isExpanded)
                    textBox(
                      timeNote,
                      style: noteStyle,
                    ),
                  Row(
                    children: [
                      textBox(
                        widget.notification.title,
                        style: titleStyle,
                      ),
                      if (!isExpanded)
                        textBox(
                          (" \u2022 $timeNote"),
                          style: noteStyle,
                        ),
                    ],
                  ),
                  textBox(
                    widget.notification.content,
                    style: contentStyle,
                    maxLines: isExpanded ? 2 : 1,
                  ),
                  if (isExpanded)
                    InkWell(
                      // onTap: widget.notification.target,
                      child: textBox(
                        "More...",
                        style: linkStyle,
                      ),
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
  final List<Notif> notifications;
  const NotifExpandableBox(this.notifications, {super.key});

  @override
  State<NotifExpandableBox> createState() => _NotifExpandableBoxState();
}

class _NotifExpandableBoxState extends State<NotifExpandableBox> {
  late List<Notif> notifications = widget.notifications;
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
    Widget titlePreview(Notif notif) {
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

    return Padding(
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
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            child: Column(
              children: List.generate(notifications.length, (_) {
                return isExpanded
                    ? NotifExpand(notifications[_])
                    : titlePreview(notifications[_]);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
