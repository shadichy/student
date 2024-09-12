import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/interpolator.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/pages/event_detail.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class NotificationDetailPage extends StatefulWidget {
  final NotificationInstance notification;

  const NotificationDetailPage(this.notification, {super.key});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    widget.notification.read();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    String target =
        "${widget.notification.applyGroupInt == null ? "" : "K${widget.notification.applyGroupInt}"}${widget.notification.applySemesterInt == null ? "" : "N${widget.notification.applySemesterInt}"} ";
    return EventPage(
      padding: const {
        "top": 0,
      },
      label: widget.notification.uploadDate == null
          ? ""
          : MiscFns.timeFormat(
              widget.notification.uploadDate!,
              format: "HH:mm dd/MM/yyyy",
            ),
      title: widget.notification.title,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => widget.notification.unread(),
                icon: const Icon(Symbols.notifications_unread),
                label: const Text("Unread"),
              ),
              TextButton.icon(
                onPressed: () => widget.notification
                    .delete()
                    .then((_) => Navigator.pop(context)),
                icon: const Icon(Symbols.clear),
                label: const Text("Clear"),
              ),
              TextButton.icon(
                onPressed: () => widget.notification.unapply(),
                icon: const Icon(Symbols.remove_from_queue),
                label: const Text("Remove from timetable"),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.notification.content,
            textAlign: TextAlign.left,
            style: textTheme.bodyMedium?.apply(color: colorScheme.onSurface),
          ),
        ),
        if (widget.notification.applyDates != null &&
            widget.notification.applyDates!.isNotEmpty)
          SubPage(
            label: "Operate at",
            desc: widget.notification.applyDates!.length == 1
                ? MiscFns.timeFormat(
                    widget.notification.uploadDate!,
                    format: "HH:mm dd/MM/yyyy",
                  )
                : "${MiscFns.timeFormat(
                    widget.notification.applyDates!.first,
                    format: "HH:mm dd/MM/yyyy",
                  )}- ${MiscFns.timeFormat(
                    widget.notification.applyDates!.last,
                    format: "HH:mm dd/MM/yyyy",
                  )}",
          ),
        SubPage(
          label: "Apply for",
          desc: target.trim().isEmpty ? "Everyone" : target,
        ),
        if (widget.notification.applyEvent != null)
          ExpansionPanelList(
            materialGapSize: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            elevation: 0,
            expansionCallback: (int index, bool isExpanded) {
              setState(() => expanded = isExpanded);
            },
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: expanded,
                headerBuilder: (_, b) => const SubPage(label: "Event timeline"),
                body: SimpleListBuilder(
                  builder: (index) {
                    var data = widget.notification.applyEvent!.timestamp[index],
                        event = UpcomingEvent.fromTimestamp(data);
                    return SubPage(
                      label: "${data.dayOfWeek}",
                      desc:
                          "${MiscFns.timeFormat(event.startTime)}- ${MiscFns.timeFormat(event.endTime)}",
                    );
                  },
                  itemCount: widget.notification.applyEvent!.timestamp.length,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
