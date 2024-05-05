import 'dart:ui';

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

  static String colorCode(Color color) =>
      color.value.toRadixString(16).substring(2, 8);

  static DateTime epoch(int s) => DateTime.fromMillisecondsSinceEpoch(s * 1000);

  static List<T> listType<T>(List<dynamic> list) =>
      list.map((s) => s as T).toList();

  // static List<Type> genList<Type>(
  //   List list, {
  //   Type Function(Type data)? callback,
  // }) =>
  //     list.map((s) => (callback ?? (_) => _)(s as Type)).toList();
}
