import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student/core/databases/user.dart';
// import 'package:student/core/configs.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/misc/misc_functions.dart';

abstract final class Server {
  static final String _domain = env["fetchDomain"]!;
  static final String _prefix = env["apiPrefix"]!;
  static Future<T> fetch<T>(String endpoint) async {
    final res = await http.get(
      Uri.https(_domain, "$_prefix/$endpoint"),
      // headers: {
      //   'Access-Control-Allow-Origin': '*',
      // },
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch from $_domain/$endpoint!");
    }
    try {
      return jsonDecode(res.body) as T;
    } catch (e) {
      throw FormatException("Failed to parse body: ", e);
    }
  }

  static Future<Map<String, dynamic>> get getStudyProgramBasics async =>
      await fetch("/basics.json");

  static Future<Map<String, dynamic>> get getTeachers async =>
      await fetch("/teachers.json");

  static Future<Map<String, dynamic>> getSubjects(TLUGroup group) async =>
      await fetch("/${group.name}/subjects.json");

  static Future<Map<String, dynamic>> getStudyPlan(TLUGroup group) async =>
      await fetch("/${group.name}/study_plan.json");

  static Future<Map<String, dynamic>> getSemester(
          TLUGroup group, TLUSemester semester) async =>
      await fetch("/${group.name}/${semester.name}/semester.json");

  static Future<MapEntry<int, List<Iterable<Map<String, dynamic>>>>>
      getNotifications(int startDate) async {
    List<int> notifIdList;
    try {
      notifIdList = MiscFns.listType<int>(
          await fetch<List>("/notifications/timestamps.json"));
    } catch (e) {
      return MapEntry(startDate, []);
    }
    List<Iterable<Map<String, dynamic>>> values = [];
    for (int _ in notifIdList.take(
      notifIdList.indexOf((startDate)),
    )) {
      values.add((await fetch<List>("/notifications/$_.json"))
          .map((e) => e as Map<String, dynamic>));
    }
    return MapEntry(notifIdList[0], values);
  }
}
