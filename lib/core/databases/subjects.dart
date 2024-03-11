import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/user.dart';

final class Subjects {
  static late final List<BaseSubject> _subjects;

  static BaseSubject? getSubject(String id) =>
      _subjects.firstWhere((BaseSubject s) => s.subjectID == id);

  static BaseSubject? getSubjectAlt(String id) =>
      _subjects.firstWhere((BaseSubject s) => s.subjectAltID == id);

  static Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("subjects");
    if (rawInfo is! String) {
      rawInfo = await Server.getSubjects(User.group);
      await SharedPrefs.setString("subjects", rawInfo);
    }

    List<Map<String, dynamic>> parsedInfo = [];

    try {
      parsedInfo = jsonDecode(rawInfo);
    } catch (e) {
      throw Exception("Failed to parse subjects info JSON from cache! $e");
    }

    _subjects = parsedInfo.map<BaseSubject>(
      (json) {
        return BaseSubject(
          subjectID: json["subjectID"] as String,
          subjectAltID: json["subjectAltID"] as String,
          name: json["name"] as String,
          tin: json["tin"] as int,
          dependencies: json["dependencies"] as List<String>,
        );
      },
    ).toList();
  }
}
