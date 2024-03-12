import 'package:intl/intl.dart';

abstract final class MiscFns {
  static String timeFormat(
    DateTime time, {
    String format = "HH:mm",
  }) =>
      DateFormat(format).format(time);

  static DateTime epoch(int s) => DateTime.fromMillisecondsSinceEpoch(s * 1000);

  static List<Type> listType<Type>(List<dynamic> l) =>
      (l).map((s) => s as Type).toList();
}
