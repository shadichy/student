import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student/core/databases/user.dart';
// import 'package:student/core/configs.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/misc/misc_functions.dart';

abstract final class Server {
  static final String _domain = env["fetchDomain"]!;
  static final String _prefix = env["apiPrefix"]!;
  static Future<String> fetch(String endpoint) async {
    final res = await http.get(
      Uri.http(_domain, "$_prefix/$endpoint"),
      // headers: {
      //   'Access-Control-Allow-Origin': '*',
      // },
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch from $_domain/$endpoint!");
    }
    return res.body;
  }

  static Future<String> get getStudyProgramBasics async =>
      await fetch("/basics.json");

  static Future<String> get getTeachers async => await fetch("/teachers.json");

  static Future<String> getSubjects(TLUGroup group) async =>
      await fetch("/${group.name}/subjects.json");

  static Future<String> getStudyPlan(TLUGroup group) async =>
      await fetch("/${group.name}/study_plan.json");

  static Future<String> getSemester(
          TLUGroup group, TLUSemester semester) async =>
      await fetch("/${group.name}/${semester.name}/semester.json");

  static Future<MapEntry<int, List<String>>> getNotifications(
      DateTime startDate) async {
    List<int> notifIdList;
    try {
      notifIdList = MiscFns.listType<int>(
          jsonDecode(await fetch("/notifications/timestamps.json")));
    } catch (e) {
      return MapEntry(startDate.millisecondsSinceEpoch ~/ 1000, []);
    }
    List<String> values = [];
    for (int _ in notifIdList.take(
      notifIdList.indexOf((startDate.millisecondsSinceEpoch / 1000).floor()),
    )) {
      values.add(await fetch("/notifications/$_.json"));
    }
    return MapEntry(notifIdList[0], values);
  }
}
