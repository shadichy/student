import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/semester/functions.dart';

extension MergeLT on SubjectCourse {
  SubjectCourse mergeLT(SubjectCourse? lt) {
    if (lt is! SubjectCourse) return this;
    return SubjectCourse(
      courseID: courseID,
      subjectID: subjectID,
      timestamp: [...lt.timestamp, ...timestamp],
    );
  }
}

class SampleTimetableData {
  late final List<Subject> subjects;
  late final Map<String, SubjectCourse> _classesLT;
  late final Map<String, String> _teacherByIds;
  Map<String, String> get teacherByIds => _teacherByIds;
  final RegExp _ltMatch = RegExp(r"_LT$");
  final RegExp _btMatch = RegExp(r"\.[0-9]_BT$");
  SampleTimetableData.from2dList(dynamic input) {
    if (input is! List) {
      throw Exception("input source is not 2d array");
    }
    subjects = [];
    _classesLT = {};
    _teacherByIds = {};
    Map<String, Map<String, dynamic>> tmpTkb = {};
    Map<String, Map<String, List<CourseTimestamp>>> tmpTkbLT = {};
    // Map<String, List<ClassTimestamp>> tmpClassesLT = {};

    for (List<String> mon in input) {
      String subjectID = mon[1];
      String name = mon[2];
      String classID = mon[3];
      String classRoom = mon[6];
      int dayOfWeek = 0;
      int classStamp = 0;
      int cred = int.parse(mon[7]);
      String teacherID = _teacherToID(mon[8]);

      if (!SPBasics().onlineClass.contains(classRoom)) {
        dayOfWeek = int.parse(mon[4]) % 7;
        classStamp = _toBits(mon[5]);
      }

      bool hasLTMatch = _ltMatch.hasMatch(classID);
      bool hasBTMatch = _btMatch.hasMatch(classID);
      CourseTimestamp stamp = CourseTimestamp(
          intStamp: SPBasics().onlineClass.contains(classRoom) ? 0 : classStamp,
          dayOfWeek: dayOfWeek,
          courseID: classID,
          teacherID: teacherID,
          room: classRoom,
          timestampType: SPBasics().onlineClass.contains(classRoom)
              ? TimestampType.online
              : TimestampType.offline,
          courseType: hasLTMatch
              ? CourseType.course
              : hasBTMatch
                  ? CourseType.subcourse
                  : null);

      if (hasLTMatch) {
        classID = classID.replaceFirst(_ltMatch, '');
        if (!tmpTkbLT.containsKey(subjectID)) {
          tmpTkbLT[subjectID] = <String, List<CourseTimestamp>>{};
        }
        if (!tmpTkbLT[subjectID]!.containsKey(classID)) {
          tmpTkbLT[subjectID]?[classID] = <CourseTimestamp>[];
        }
        tmpTkbLT[subjectID]?[classID]!.add(stamp);
        // if (!tmpClassesLT.containsKey(classID)) {
        //   tmpClassesLT[classID] = [stamp];
        // } else {
        //   tmpClassesLT[classID]?.add(stamp);
        // }
        continue;
      }

      if (!tmpTkb.containsKey(subjectID)) {
        tmpTkb[subjectID] = {
          "name": name,
          "cred": cred,
          "classes": <String, List<CourseTimestamp>>{},
        };
      }

      if (!tmpTkb[subjectID]?["classes"].containsKey(classID)) {
        tmpTkb[subjectID]?["classes"][classID] = <CourseTimestamp>[];
      }
      tmpTkb[subjectID]?["classes"]?[classID].add(stamp);
    }

    tmpTkbLT.forEach(
      (subjectID, classes) => classes.forEach(
        (classID, timestamp) => _classesLT[classID] = SubjectCourse(
          subjectID: subjectID,
          courseID: classID,
          timestamp: timestamp,
        ),
      ),
    );

    // tmpClassesLT.forEach((classID, timestamp) => _classesLT[classID] = SubjectClass(
    //       subjectID: subjectID,
    //       classID: classID,
    //       timestamp: timestamp,
    //     ));

    tmpTkb.forEach(
      (String subjectID, subjectInfo) {
        List<SubjectCourse> courses =
            _mapToClass(subjectID, subjectInfo["classes"]);
        return subjects.add(Subject.fromBase(
          BaseSubject.fromJson({
            "name": subjectInfo["name"].toString(),
            "cred": subjectInfo["cred"],
            "coef": subjectInfo["cred"],
            "subjectAltID": courses[0]
                .courseID
                .replaceFirst(RegExp(r"(\.[0-9])+(_[LB]T)?$"), ''),
            "dependencies": [],
          }, subjectID),
          courses.asMap().map((_, v) => MapEntry(v.courseID, v)),
        ));
      },
    );
  }
  SampleTimetableData.fromObject(Object input) {
    if (input is! Map<String, dynamic>) {
      throw Exception("input source is not JSON object");
    }

    Map<String, Map<String, dynamic>> tmpTkb = {};
    Map<String, Map<String, List<CourseTimestamp>>> tmpTkbLT = {};

    input.forEach((subjectID, subjectInfo) {
      if (subjectInfo is! Map<String, dynamic>) {
        throw Exception("input source is not JSON object");
      }
      if (subjectInfo["classes"] is! Map<String, List>) {
        throw Exception("input source is not JSON object");
      }
      String name = subjectInfo["name"];
      String cred = subjectInfo["cred"];

      subjectInfo["classes"]
          ?.forEach((classID, List<Map<String, dynamic>> classInfo) {
        List<CourseTimestamp> stampList = classInfo
            .map((stamp) => CourseTimestamp(
                  intStamp: SPBasics().onlineClass.contains(stamp["room"])
                      ? 0
                      : _toBits(stamp["ca"]),
                  dayOfWeek: SPBasics().onlineClass.contains(stamp["room"])
                      ? 0
                      : (int.parse(stamp["dayOfWeek"]) - 1),
                  courseID: classID,
                  teacherID: stamp['teacherID'],
                  room: stamp["room"],
                  timestampType: SPBasics().onlineClass.contains(stamp["room"])
                      ? TimestampType.online
                      : TimestampType.offline,
                ))
            .toList();
        if (_ltMatch.hasMatch(classID)) {
          if (tmpTkbLT.containsKey(subjectID)) {
            tmpTkbLT[subjectID] = {};
          }
          classID = classID.replaceFirst(_ltMatch, '');
          tmpTkbLT[subjectID]?[classID] = stampList;
          return;
        }

        if (!tmpTkb.containsKey(subjectID)) {
          tmpTkb[subjectID] = {
            "name": name,
            "cred": cred,
            "classes": <String, List<CourseTimestamp>>{},
          };
        }

        if (!tmpTkb[subjectID]?["classes"].containsKey(classID)) {
          tmpTkb[subjectID]?["classes"][classID] = <CourseTimestamp>[];
        }
        tmpTkb[subjectID]?["classes"]?[classID] = stampList;
      });
    });

    tmpTkbLT.forEach((subjectID, classes) => classes
        .forEach((classID, timestamp) => _classesLT[classID] = SubjectCourse(
              subjectID: subjectID,
              courseID: classID,
              timestamp: timestamp,
            )));

    tmpTkb.forEach(
      (String subjectID, subjectInfo) => subjects.add(Subject.fromBase(
        BaseSubject.fromJson({
          "name": subjectInfo["name"].toString(),
          "cred": subjectInfo["cred"],
          "coef": subjectInfo["coef"],
          "dependencies": [],
        }, subjectID),
        _mapToClass(subjectID, subjectInfo["classes"])
            .asMap()
            .map((_, v) => MapEntry(v.courseID, v)),
      )),
    );
  }

  static String unifyJson(String input) {
    return input;
  }

  // int _add0(int i, int n) => i << n;
  // int _add1(int i, int n) => (i << (n + 1)) + (2 << n) - 1;
  int _toStamp(int s, int e) => ((2 << (e - s)) - 1) << (s - 1);

  int _toBits(String str) {
    if (str == "0-0") return 0;
    List<int> e = str.split("-").map(int.parse).toList(growable: false);
    return _toStamp(e[0], e[1]);
    // return _add0(_add1(0, e[1] - e[0]), e[0] - 1);
  }

  String _teacherToID(String str) {
    if (str.isEmpty) {
      return "";
    }

    RegExp teacherIDFilter = RegExp(r"\([A-Z]{3}[0-9]{3}\)");

    String teacherID = teacherIDFilter.stringMatch(str).toString();
    teacherID = teacherID.substring(1, teacherID.length - 1);

    if (!_teacherByIds.containsKey(teacherID)) {
      _teacherByIds[teacherID] = str.replaceFirst(teacherIDFilter, '');
    }

    return teacherID;
  }

  List<SubjectCourse> _mapToClass(
      String id, Map<String, List<CourseTimestamp>> info) {
    List<SubjectCourse> tmpClasses = [];
    info.forEach((classID, timestamp) {
      if (_btMatch.hasMatch(id)) {
        classID = classID.replaceFirst(RegExp(r"_BT$"), '');
      }
      SubjectCourse tmpClass = SubjectCourse(
        subjectID: id,
        courseID: classID,
        timestamp: timestamp,
      );
      if (_btMatch.hasMatch(id)) {
        tmpClass = tmpClass.mergeLT(_classesLT[id.replaceFirst(_btMatch, '')]);
      }
      tmpClasses.add(tmpClass);
    });
    return tmpClasses;
  }

  String? teacher(String id) => _teacherByIds[id];
}

// void main(List<String> args) {
//   List dinput =
//       jsonDecode(File("./test/sample_tkb.test.json").readAsStringSync());
//   List<List<String>> input = [];
//   dinput.toList().forEach((k) {
//     List<String> tmp = [];
//     k.toList().forEach((t) => tmp.add(t.toString()));
//     input.add(tmp);
//   });
//   SubjectList lmao = SubjectList.from2dList(input);
//   for (Subject s in lmao.timetable) {
//     print("${s.subjectID}: ");
//     print("  Name: ${s.name}");
//     print("  Tin chi: ${s.tin}");
//     for (SubjectClass c in s.classes) {
//       print("    Lop: ${c.classID}");
//       print("    intMatrix: ${c.intMatrix}");
//     }
//   }
//   GenTkb k = GenTkb(lmao.timetable, {
//     "IS222": SubjectFilter(inClass: ["CSODULIEU.7", "CSODULIEU.8"]),
//     "VC204": SubjectFilter(),
//   });
//   for (SampleTkb s in k.output) {
//     print("${s.intMatrix}: ");
//     for (SubjectClass c in s.classes) {
//       print("    Lop: ${c.classID}");
//       print("    intMatrix: ${c.intMatrix}");
//     }
//   }
// }
