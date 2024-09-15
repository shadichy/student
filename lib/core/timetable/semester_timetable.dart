import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:student/core/semester/functions.dart';

part 'semester_timetable.g.dart';

@HiveType(typeId: 9)
class WeekTimetable extends HiveObject {
  @HiveField(0)
  final DateTime startDate; // must be start of week

  @HiveField(1)
  List<EventTimestamp> get timestamps => _timestamps;
  List<EventTimestamp> _timestamps;

  @HiveField(2)
  final int? weekNo;

  WeekTimetable(
    List<EventTimestamp> timestamps, {
    required this.startDate,
    this.weekNo,
  }) : _timestamps = timestamps;

  Future<void> addStamps(Iterable<EventTimestamp> timestamp) async {
    _timestamps.addAll(timestamp);
    await save();
  }

  Future<void> setStamps(List<EventTimestamp> timestamp) async {
    _timestamps = timestamp;
    await save();
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'startDate': (startDate.millisecondsSinceEpoch / 1000).floor(),
        'timestamps': _timestamps,
        'weekNo': weekNo,
      };

  @override
  String toString() => jsonEncode(toMap());
}
