import 'package:flutter/widgets.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/misc/misc_functions.dart';

enum UserGroup { n1, n2, n3 }

enum UserSemester { k1, k2, k3 }

class User {
  User._instance();
  static final _userInstance = User._instance();
  factory User() {
    return _userInstance;
  }

  late final String id;
  late final String name;
  late final ImageProvider<Object>? picture;
  late final UserGroup group;
  late final UserSemester semester;
  late final int schoolYear;
  // only be in ID
  // late final List<String> passedSubjectIDs;
  // can be either ID or Alt ID
  // late final List<String> learningCourseIDs;
  late final List<Map<UserSemester, List<String>>> learningCourses;
  late final String? major; // later
  late final String? majorClass; // later
  late final int? majorCred; // later
  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    Map<String, dynamic>? parsedInfo = SharedPrefs.getString("user");
    if (parsedInfo == null) {
      throw Exception("Could not get user info from cache!");
    }

    id = parsedInfo["id"] as String;
    name = parsedInfo["name"] as String;
    parsedInfo["picture"] is String
        ? picture = NetworkImage(parsedInfo["picture"])
        : picture = const AssetImage("assets/images/thanglong_logo.png");
    group = UserGroup.values[parsedInfo["group"] as int];
    semester = UserSemester.values[parsedInfo["semester"] as int];
    schoolYear = parsedInfo["schoolYear"] as int;
    learningCourses = (parsedInfo["learning"] as List).map((v) {
      return (v as List).asMap().map((key, value) {
        return MapEntry(
          UserSemester.values[key],
          MiscFns.listType<String>(value as List),
        );
      });
    }).toList();
    _initialized = true;
  }
}
