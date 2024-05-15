import 'package:flutter/widgets.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/misc/misc_functions.dart';

enum TLUGroup { n1, n2, n3 }

enum TLUSemester { k1, k2, k3 }

class User {
  User._instance();
  static final _userInstance = User._instance();
  factory User() {
    return _userInstance;
  }

  late final String id;
  late final String name;
  late final ImageProvider<Object>? picture;
  late final TLUGroup group;
  late final TLUSemester semester;
  late final int schoolYear;
  final int currentSchoolYear = 36;
  // only be in ID
  // late final List<String> passedSubjectIDs;
  // can be either ID or Alt ID
  // late final List<String> learningCourseIDs;
  late final List<Map<TLUSemester, List<String>>> learningCourses;
  late final String? major; // later
  late final String? majorClass; // later
  late final int? majorCred; // later
  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> initialize() async {
    Map<String, dynamic>? parsedInfo = SharedPrefs.getString("user");
    if (parsedInfo == null) {
      throw Exception("Could not get user info from cache!");
    }

    id = parsedInfo["id"] as String;
    name = parsedInfo["name"] as String;
    parsedInfo["picture"] is String
        ? picture = NetworkImage(parsedInfo["picture"])
        : picture = const AssetImage("assets/images/thanglong_logo.png");
    group = TLUGroup.values[parsedInfo["group"] as int];
    semester = TLUSemester.values[parsedInfo["semester"] as int];
    schoolYear = parsedInfo["schoolYear"] as int;
    learningCourses = (parsedInfo["learning"] as List).map((v) {
      return (v as List).asMap().map((key, value) {
        return MapEntry(
          TLUSemester.values[key],
          MiscFns.listType<String>(value as List),
        );
      });
    }).toList();
    _initialized = true;
  }
}
