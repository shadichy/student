import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';

final class Teachers {
  static late final Map<String, String> _teachers;
  static String? getTeacher(String id) => _teachers[id];

  static Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("teachers");
    if (rawInfo is! String) {
      rawInfo = await Server.getTeachers;
      await SharedPrefs.setString("teachers", rawInfo);
    }

    Map<String, String> parsedInfo = {};

    try {
      parsedInfo = jsonDecode(rawInfo);
    } catch (e) {
      throw Exception("Failed to parse teachers info JSON from cache! $e");
    }

    _teachers = parsedInfo;
  }
}
