import 'dart:ui';

import 'package:intl/intl.dart';

abstract final class MiscFns {
  static String timeFormat(
    DateTime time, {
    String format = "HH:mm",
  }) =>
      DateFormat(format).format(time);

  static String durationLeft(Duration start) {
    String hour = "";
    String min = "${start.inMinutes % 60}m";
    if (start.inHours > 0) {
      hour += "${start.inHours}h";
      if (start.inMinutes == 0) min = "";
    }
    if (start.inMinutes <= 0) return "now";
    return "$hour$min";
  }

  static String timeLeft(DateTime startTime, DateTime endTime) {
    return (endTime.difference(DateTime.now()).inMinutes > 0)
        ? durationLeft(startTime.difference(DateTime.now()))
        : "ended";
  }

  static String colorCode(Color color) =>
      color.value.toRadixString(16).substring(2, 8);

  static DateTime epoch(int s) => DateTime.fromMillisecondsSinceEpoch(s * 1000);

  static List<T> list<T>(List<dynamic> list) =>
      list.map((s) => s as T).toList();

  // static List<Type> genList<Type>(
  //   List list, {
  //   Type Function(Type data)? callback,
  // }) =>
  //     list.map((s) => (callback ?? (_) => _)(s as Type)).toList();
}
