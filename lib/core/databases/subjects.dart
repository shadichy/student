import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/iterable_extensions.dart';

final class Subjects {
  Subjects._instance();
  static final _subjectsInstance = Subjects._instance();
  factory Subjects() {
    return _subjectsInstance;
  }
  late final Iterable<BaseSubject> _subjects;

  BaseSubject? getSubject(String id) =>
      _subjects.firstWhereIf((_) => _.subjectID == id);

  BaseSubject? getSubjectAlt(String id) =>
      _subjects.firstWhereIf((_) => _.subjectAltID == id);

  Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("subjects");
    if (rawInfo is! String) {
      rawInfo = await Server.getSubjects(User().group);
      await SharedPrefs.setString("subjects", rawInfo);
    }

    Map<String, Map<String, dynamic>> parsedInfo = {};

    try {
      parsedInfo = (jsonDecode(rawInfo) as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as Map<String, dynamic>));
    } catch (e) {
      throw Exception("Failed to parse subjects info JSON from cache! $e");
    }

    _subjects = parsedInfo.map<String, BaseSubject>((key, value) {
      return MapEntry(
        key,
        BaseSubject(
          subjectID: key,
          subjectAltID: value["subjectAltID"] as String,
          name: value["name"] as String,
          cred: value["cred"] as int,
          dependencies: MiscFns.listType<String>(value["dependencies"] as List),
        ),
      );
    }).values;
  }
}
