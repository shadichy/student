// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter_test/flutter_test.dart';
// import 'package:student/core/semester/functions.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:student/core/databases/server.dart';
// import 'package:student/core/databases/shared_prefs.dart';
// import 'package:student/core/databases/user.dart';

// import 'package:student/misc/parser.dart';

void main() {
  // List<Widget> a = [Text("")];
  // List<Widget> b = [a, Text("")];
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {});
  // print(jsonDecode(
  //   File("test/sample_tkb.test.json").readAsStringSync(),
  // )[0][1]);
  // var r = RegExp(r"(\.[0-9])+(_[LB]T)?$");
  // var s = "TIN&VIETTIN.1.1_BT";
  // print(r.hasMatch(s));
  // print(s.replaceFirst(r, ''));
  // var t = SampleTimetableData.from2dList((jsonDecode(
  //   File("test/sample_tkb.test.json").readAsStringSync(),
  // ) as List)
  //     .map((s) => (s as List).map((e) => e as String).toList())
  //     .toList());

  // File('test/sample_db/n3/subjects.json').writeAsStringSync(jsonEncode(
  //     t.subjects.asMap().map((k, e) => MapEntry(e.subjectID, e.toBase()))));
  // File('test/sample_db/n3/k2/semester.json').writeAsStringSync(jsonEncode(
  //     t.subjects.asMap().map((k, v) => MapEntry(v.subjectID, v.courses))));
  // File('test/sample_db/teachers.json')
  // .writeAsStringSync(jsonEncode(t.teacherByIds));
  // print(t.teacherByIds);
  // http
  //     .get(Uri.http("localhost:8080", "sample_db//teachers.json"))
  //     .then((value) => print(value.body));
  // SharedPrefs.setString(
  //   "user",
  //   '{"id":"A47548","name":"Sadashi Ken Ichi","group":2,"semester":1,"schoolYear":36,"passed":[],"learning":[]}',
  // );
  // Server.getTeachers.then((value) => print(value));
  // Server.getSubjects(TLUGroup.n3).then((value) => print(value));
  // print(jsonEncode(0));
  // print(jsonEncode(""));
  // print(jsonEncode(true));
  // print(jsonEncode(5.6));
  // print(jsonEncode(["a"]));
  // print(jsonEncode({'`a.b': 'c'}));
  // print(DateTime(2024, 9, 6, 7, 0, 0)
  //         .difference(DateTime.fromMillisecondsSinceEpoch(589446000000))
  //         .inDays /
  //     365.25);
  // print(RegExp(r'([^.]+)').firstMatch("NHATSC2.3")![0]);
  // print(DateTime.fromMillisecondsSinceEpoch(1790045200 * 1000)
  //         .subtract(Duration(days: 365 * 3 + 1))
  //         .millisecondsSinceEpoch ~/
  //     1000);
  print(DateTime.parse("2023-07-24").millisecondsSinceEpoch);
}
