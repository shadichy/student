import 'package:student/core/databases/server.dart';

@Deprecated("moving to Hive")
final class Teachers {
  Teachers._instance();
  static final _teachersInstance = Teachers._instance();
  factory Teachers() {
    return _teachersInstance;
  }

  late final Map<String, String> _teachers;
  String? getTeacher(String id) => _teachers[id];

  Future<void> initialize() async {
    Map<String, dynamic>? rawInfo = await Server.getTeachers;

    Map<String, String> parsedInfo = {};

    try {
      parsedInfo = rawInfo.map((key, value) => MapEntry(key, value as String));
    } catch (e) {
      throw Exception("Failed to parse teachers info JSON from cache! $e");
    }

    _teachers = parsedInfo;
  }
}
