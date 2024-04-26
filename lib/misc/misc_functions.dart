import 'package:intl/intl.dart';

abstract final class MiscFns {
  static String timeFormat(
    DateTime time, {
    String format = "HH:mm",
  }) =>
      DateFormat(format).format(time);

  static String timeLeft(DateTime startTime, DateTime endTime) {
    Duration diffEnd = endTime.difference(DateTime.now());
    if (diffEnd.inMinutes < 0) return "ended";
    Duration diffStart = startTime.difference(DateTime.now());
    String hour = "";
    if (diffStart.inHours > 0) hour += "${diffStart.inHours}h";
    if (diffStart.inMinutes < 0) return "now";
    return "$hour${diffStart.inMinutes}m";
  }

  static DateTime epoch(int s) => DateTime.fromMillisecondsSinceEpoch(s * 1000);

  static List<Type> listType<Type>(List<dynamic> l) =>
      (l).map((s) => s as Type).toList();
}
