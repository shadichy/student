import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:restart_app/restart_app.dart';
import 'package:student/core/databases/shared_prefs.dart';
// import 'package:http/http.dart' as http;
import 'package:student/core/databases/user.dart';
// import 'package:student/core/configs.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/misc/misc_functions.dart';

abstract final class Server {
  static final Map<String, dynamic> _env = SharedPrefs.getString("env");
  static final String _domain = _env["fetchDomain"] ?? env["fetchDomain"]!;
  static final String _prefix = _env["apiPrefix"] ?? env["apiPrefix"] ?? "";

  static String url(String endpoint) =>
      "https://$_domain/$_prefix/$endpoint.json";

  static CacheManager iCM = CacheManager(Config(
    "student_app",
    stalePeriod: const Duration(days: 30),
  ));

  static Future<void> kill() async {
    await iCM.removeFile("notifications");
    await iCM.removeFile("basics");
    await iCM.removeFile("teachers");
    await iCM.removeFile("${User().group.name}/subjects");
    await iCM.removeFile("${User().group.name}/study_plan");
    await iCM.removeFile(
      "${User().group.name}/${User().semester.name}/semester",
    );
    await SharedPrefs.clear();
    Restart.restartApp();
  }

  static Future<T> download<T>(String endpoint) async {
    try {
      return jsonDecode((await iCM.downloadFile(url(endpoint), force: true))
          .file
          .readAsStringSync());
    } catch (e) {
      throw FormatException("Failed to get file $endpoint: ", e);
    }
  }

  static Future<T?> getString<T>(String key, [T? defaultValue]) async {
    try {
      return jsonDecode(
          (await iCM.getFileFromCache(key))!.file.readAsStringSync());
    } catch (e) {
      return defaultValue;
    }
  }

  static Future<void> setString(String key, Object value) async {
    await iCM.putFile(key, const Utf8Encoder().convert(jsonEncode(value)));
  }

  static Future<T> fetch<T>(String endpoint) async {
    try {
      return jsonDecode((await iCM.getSingleFile(url(endpoint), key: endpoint))
          .readAsStringSync()) as T;
    } catch (e) {
      throw FormatException("Failed to get file $endpoint: ", e);
    }
  }

  static Future<Map<String, dynamic>> get getStudyProgramBasics async =>
      await fetch("basics");

  static Future<Map<String, dynamic>> get getTeachers async =>
      await fetch("teachers");

  static Future<Map<String, dynamic>> getSubjects(UserGroup group) async =>
      await fetch("${group.name}/subjects");

  static Future<Map<String, dynamic>> getStudyPlan(UserGroup group) async =>
      await fetch("${group.name}/study_plan");

  static Future<Map<String, dynamic>> getSemester(
          UserGroup group, UserSemester semester) async =>
      await fetch("${group.name}/${semester.name}/semester");

  static Future<MapEntry<int, List<Iterable<Map<String, dynamic>>>>>
      getNotifications(int startDate) async {
    List<int> notifIdList;
    try {
      notifIdList = MiscFns.listType<int>(
          await download<List>("notifications/timestamps"));
    } catch (e) {
      return MapEntry(startDate, []);
    }
    List<Iterable<Map<String, dynamic>>> values = [];
    for (int notif in notifIdList.take(
      notifIdList.indexOf((startDate)),
    )) {
      values.add((await download<List>("notifications/$notif"))
          .map((e) => e as Map<String, dynamic>));
    }
    return MapEntry(notifIdList[0], values);
  }
}
