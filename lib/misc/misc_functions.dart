import 'package:intl/intl.dart';

String timeFormat(
  DateTime time, {
  String format = "HH:mm",
}) =>
    DateFormat(format).format(time);
