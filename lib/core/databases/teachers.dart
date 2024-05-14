
import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';

final class Teachers {
  Teachers._instance();
  static final _teachersInstance = Teachers._instance();
  factory Teachers() {
    return _teachersInstance;
  }

  late final Map<String, String> _teachers;
  String? getTeacher(String id) => _teachers[id];

  Future<void> initialize() async {
    Map<String, dynamic>? rawInfo = SharedPrefs.getString("teachers");
    if (rawInfo == null) {
      rawInfo = await Server.getTeachers;
      await SharedPrefs.setString("teachers", rawInfo);
    }

    Map<String, String> parsedInfo = {};

    try {
      parsedInfo = rawInfo.map((key, value) => MapEntry(key, value as String));
    } catch (e) {
      throw Exception("Failed to parse teachers info JSON from cache! $e");
    }

    _teachers = parsedInfo;
  }
}
