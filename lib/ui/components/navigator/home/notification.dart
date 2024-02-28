import 'package:flutter/material.dart';
import 'package:student/ui/components/interpolator.dart';

class Notif {
  final String title;
  final String content;
  final DateTime? time;
  final void Function()? target;
  Notif(this.title, {required this.content, this.time, this.target});
}

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
    TextStyle genericStyle({double? fontSize, FontWeight? fontWeight}) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: colorScheme.onPrimaryContainer,
      );
    }

    TextStyle titleStyle = genericStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    TextStyle contentStyle = genericStyle(
      fontSize: 14,
    );
    TextStyle noteStyle = genericStyle(
      fontSize: 12,
      fontWeight: FontWeight.w100,
    );
    TextStyle linkStyle = genericStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    String timeNote = (widget.notification.time is DateTime)
        ? (<String>(Duration? d) {
            return "${d!.inHours > 0 ? "${d.inHours}h" : ""}${d.inMinutes}m";
          })(widget.notification.time?.difference(DateTime.now()))
        : "now";

    Widget textBox(String text, {TextStyle? style, int? maxLines}) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    return InkWell(
      onTap: isExpanded ? widget.notification.target : null,
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
                        (" \u00B7 $timeNote"),
                        style: noteStyle,
                      ),
                  ],
                ),
                textBox(
                  widget.notification.content,
                  style: contentStyle,
                  maxLines: isExpanded ? 8 : 1,
                ),
                if (isExpanded)
                  InkWell(
                    onTap:widget.notification.target,
                    child: textBox(
                      "More",
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
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: colorScheme.onSecondaryContainer),
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
  late List<Notif> notifications;
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
    notifications = widget.notifications;
    // print(widget.notifications);
    Widget titlePreview(Notif notif) {
      return Padding(
        padding: const EdgeInsets.only(left: 32, right: 24),
        child: Row(
          children: [
            Text(
              "${notif.title}  ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.onPrimaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              child: Text(
                notif.content,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onPrimaryContainer,
                ),
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
        children: Interpolator<Widget>([
          [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withOpacity(0.05),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.notifications,
                    color: colorScheme.onPrimaryContainer,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Latest Notifications",
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                      ),
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
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16,
                        color: colorScheme.onSecondaryContainer),
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
            )
          ],
          notifications.map((Notif n) {
            return isExpanded ? NotifExpand(n) : titlePreview(n);
          }).toList()
        ]).output,
      ),
    );
  }
}
