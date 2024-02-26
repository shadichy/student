import 'package:flutter/material.dart';

class Notif {
  final String title;
  final String content;
  final void Function()? target;
  Notif(this.title, {required this.content, this.target});
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
    TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold);
    TextStyle contentStyle = TextStyle();
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
        mainAxisAlignment:
            isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  textBox(widget.notification.title, style: titleStyle),
                  if (!isExpanded)
                    Expanded(
                      child: textBox(
                        widget.notification.content,
                        style: contentStyle,
                      ),
                    ),
                ],
              ),
              if (isExpanded)
                textBox(
                  widget.notification.content,
                  style: contentStyle,
                  maxLines: 64,
                )
            ],
          ),
          IconButton(
            onPressed: changeState,
            icon: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 16,
              color: colorScheme.onSecondaryContainer
            ),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primary.withOpacity(0.05),
            ),
            splashRadius: 2,
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

  @override
  Widget build(BuildContext context) {
    notifications = widget.notifications;
    return const Placeholder();
  }
}
