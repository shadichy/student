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
  late final ImageProvider<Object> picture;
  late final String? pictureUri;
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
  late final int? credits; // later
  bool _initialized = false;

  bool get initialized => _initialized;

  void setUser(Map<String, dynamic> data) {
    id = data["id"] as String;
    name = data["name"] as String;
    data["picture"] is String
        ? picture = NetworkImage(data["picture"])
        : picture = const AssetImage("assets/images/logo.png");
    pictureUri = data["picture"];
    group = UserGroup.values[data["group"] as int];
    semester = UserSemester.values[data["semester"] as int];
    schoolYear = data["schoolYear"] as int;
    learningCourses = (data["learning"] as List).map((v) {
      return ((v is List) ? v.asMap() : v as Map).map((key, value) {
        return MapEntry(
          UserSemester.values[key],
          (value as List).cast<String>(),
        );
      });
    }).toList();
    major = data["major"];
    majorClass = data["majorClass"];
    majorCred = data["majorCred"];
    credits = data["credits"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "picture": pictureUri,
        "group": group.index,
        "semester": semester.index,
        "schoolYear": schoolYear,
        "major": major,
        "majorClass": majorClass,
        "majorCred": majorCred,
        "credits": credits,
        "learningCourses": learningCourses.map((l) {
          return l.map((key, value) => MapEntry(key.index, value));
        }),
      };

  Future<void> initialize() async {
    if (_initialized) return;
    Map<String, dynamic>? parsedInfo = SharedPrefs.getString("user");
    if (parsedInfo == null) {
      throw Exception("Could not get user info from cache!");
    }
    setUser(parsedInfo);
    _initialized = true;
  }
}
