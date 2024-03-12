import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:student/core/databases/shared_prefs.dart';

enum TLUGroup { n1, n2, n3 }

enum TLUSemester { k1, k2, k3 }

class User {
  User._instance() {
    initialize();
  }
  factory User() {
    return _userInstance;
  }
  static final _userInstance = User._instance();

  late final String id;
  late final String name;
  late final ImageProvider<Object>? picture;
  late final TLUGroup group;
  late final TLUSemester semester;
  late final int schoolYear;
  // only be in ID
  late final List<String> passedSubjectIDs;
  // can be either ID or Alt ID
  late final List<String> learningCourseIDs;
  late final String? major; // later
  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> initialize() async {
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
    passedSubjectIDs = (parsedInfo["passed"] as List<dynamic>).map((s) => s as String).toList();
    learningCourseIDs = (parsedInfo["learning"] as List<dynamic>).map((s) => s as String).toList();
    _initialized = true;
  }
}
