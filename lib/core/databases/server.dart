import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:http/http.dart' as http;
import 'package:student/core/databases/user.dart';
// import 'package:student/core/configs.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/misc/misc_functions.dart';

abstract final class Server {
  static final String _domain = env["fetchDomain"]!;
  static final String _prefix = env["apiPrefix"] ?? "";

  static String url(String endpoint) => "https://$_domain/$_prefix/$endpoint.json";

  static CacheManager instanceCacheManager = CacheManager(Config(
    "student_app",
    stalePeriod: const Duration(days: 30),
  ));

  static Future<T> download<T>(String endpoint) {}

  static Future<T> getString<T>(String key) {}

  static Future<void> setString(String key, Object value) {}

  static Future<T> fetch<T>(String endpoint) async {
    // final res = await http.get(
    //   Uri.https(_domain, "$_prefix/$endpoint"),
    //   // headers: {
    //   //   'Access-Control-Allow-Origin': '*',
    //   // },
    // );
    // if (res.statusCode != 200) {
    //   throw Exception("Failed to fetch from $_domain/$endpoint!");
    // }
    try {
      return jsonDecode((await instanceCacheManager
              .getSingleFile(url(endpoint)), key: endpoint,)
          .readAsStringSync(),) as T;
    } catch (e) {
      throw FormatException("Failed to get file $endpoint: ", e);
    }
  }

  static Future<Map<String, dynamic>> get getStudyProgramBasics async =>
      await fetch("basics");

  static Future<Map<String, dynamic>> get getTeachers async =>
      await fetch("teachers");

  static Future<Map<String, dynamic>> getSubjects(TLUGroup group) async =>
      await fetch("${group.name}/subjects");

  static Future<Map<String, dynamic>> getStudyPlan(TLUGroup group) async =>
      await fetch("${group.name}/study_plan");

  static Future<Map<String, dynamic>> getSemester(
          TLUGroup group, TLUSemester semester) async =>
      await fetch("${group.name}/${semester.name}/semester");

  static Future<MapEntry<int, List<Iterable<Map<String, dynamic>>>>>
      getNotifications(int startDate) async {
    List<int> notifIdList;
    try {
      notifIdList = MiscFns.listType<int>(
        jsonDecode((await instanceCacheManager.downloadFile(
          "https://$_domain/$_prefix/notifications/timestamps.json",
          force: true,
        ))
            .file
            .readAsStringSync()),
      );
    } catch (e) {
      return MapEntry(startDate, []);
    }
    List<Iterable<Map<String, dynamic>>> values = [];
    for (int notif in notifIdList.take(
      notifIdList.indexOf((startDate)),
    )) {
      values.add((await fetch<List>("notifications/$notif"))
          .map((e) => e as Map<String, dynamic>));
    }
    return MapEntry(notifIdList[0], values);
  }
}
