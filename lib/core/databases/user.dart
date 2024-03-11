import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:student/core/databases/shared_prefs.dart';

enum TLUGroup { n1, n2, n3 }

enum TLUSemester { k1, k2, k3 }

final class User {
  static late final String id;
  static late final String name;
  static late final ImageProvider<Object>? picture;
  static late final TLUGroup group;
  static late final TLUSemester semester;
  static late final int schoolYear;
  // only be in ID
  static late final List<String> passedSubjectIDs;
  // can be either ID or Alt ID
  static late final List<String> learningCourseIDs;
  static bool initialized = false;

  static Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("user");
    if (rawInfo is! String) {
      throw Exception("Could not get user info from cache!");
    }

    Map<String, dynamic> parsedInfo = {};

    try {
      parsedInfo = jsonDecode(rawInfo);
    } catch (e) {
      throw Exception("Failed to parse user info JSON from cache! $e");
    }

    id = parsedInfo["id"] as String;
    name = parsedInfo["name"] as String;
    parsedInfo["picture"] is String
        ? picture = NetworkImage(parsedInfo["picture"])
        : picture = const AssetImage("assets/images/thanglong_logo.png");
    group = TLUGroup.values[parsedInfo["group"] as int];
    semester = TLUSemester.values[parsedInfo["semester"] as int];
    schoolYear = parsedInfo["schoolYear"] as int;
    passedSubjectIDs = parsedInfo["passed"] as List<String>;
    learningCourseIDs = parsedInfo["learning"] as List<String>;
    initialized = true;
  }
}
