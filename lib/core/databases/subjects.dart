import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/iterable_extensions.dart';

@Deprecated("moving to Hive")
final class Subjects {
  Subjects._instance();
  static final _subjectsInstance = Subjects._instance();
  factory Subjects() {
    return _subjectsInstance;
  }
  late final Iterable<BaseSubject> _subjects;

  String _getCourseID(String id) => RegExp(r'([^.]+)').firstMatch(id)![0]!;

  BaseSubject? getSubject(String id) =>
      _subjects.firstWhereIf((s) => s.subjectID == id);

  BaseSubject? getSubjectAlt(String id) =>
      _subjects.firstWhereIf((s) => s.subjectAltID == _getCourseID(id));

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
        BaseSubject.fromJson(value, key),
      );
    }).values;
  }
}
