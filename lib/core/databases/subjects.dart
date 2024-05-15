import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/iterable_extensions.dart';

final class Subjects {
  Subjects._instance();
  static final _subjectsInstance = Subjects._instance();
  factory Subjects() {
    return _subjectsInstance;
  }
  late final Iterable<BaseSubject> _subjects;

  BaseSubject? getSubject(String id) =>
      _subjects.firstWhereIf((s) => s.subjectID == id);

  BaseSubject? getSubjectAlt(String id) =>
      _subjects.firstWhereIf((s) => s.subjectAltID == id);

  Future<void> initialize() async {
    Map<String, dynamic> rawInfo = await Server.getSubjects(User().group);

    Map<String, Map<String, dynamic>> parsedInfo = {};

    try {
      parsedInfo = rawInfo
          .map((key, value) => MapEntry(key, value as Map<String, dynamic>));
    } catch (e) {
      throw Exception("Failed to parse subjects info JSON from cache! $e");
    }

    _subjects = parsedInfo.map<String, BaseSubject>((key, value) {
      return MapEntry(
        key,
        BaseSubject(
          subjectID: key,
          subjectAltID: value["subjectAltID"] as String,
          name: value["name"] as String,
          cred: value["cred"] as int,
          dependencies: MiscFns.listType<String>(value["dependencies"] as List),
        ),
      );
    }).values;
  }
}
