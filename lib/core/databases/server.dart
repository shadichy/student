import 'package:http/http.dart' as http;
import 'package:student/core/databases/user.dart';
import 'package:student/core/configs.dart';
import 'package:student/misc/parser.dart';

abstract final class Server {
  static final String _url = env["fetchUrl"]!;
  static Future<String> fetch(String endpoint) async {
    final res = await http.get(Uri.parse("$_url/$endpoint"));
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch from $_url/$endpoint!");
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
      SampleTimetableData.unifyJson(
          await fetch("/${group.name}/${semester.name}/semester.json"));
}
