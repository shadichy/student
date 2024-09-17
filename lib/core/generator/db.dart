import 'package:hive_flutter/hive_flutter.dart';
import 'package:student/core/generator/generator.dart';

final class GenDB {
  GenDB._g();
  static final _ = GenDB._g();
  factory GenDB() => _;

  bool _inittialized = false;

  static const String _boxName = "samples";
  late final Box<SampleTimetable> _box;

  Future<void> init() async {
    if (_inittialized) return;

    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(SampleTimetableAdapter());
    }

    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<SampleTimetable>(_boxName);
    }

    _inittialized = true;
  }

  Future<void> deinit() async {
    if (!_inittialized) return;

    await _box.clear();

    _inittialized = false;
  }

  Future<void> add(SampleTimetable timetable) async => await _box.put(timetable.hashCode,timetable);

  Future<void> remove(SampleTimetable timetable) async => await _box.delete(timetable.hashCode);

  List<SampleTimetable> get values => _box.values.toList();
}
