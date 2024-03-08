import 'package:student/core/presets.dart';
import 'package:student/core/functions.dart';

class TimetableData {
  late final List<Subject> timetable;
  late final Map<String, SubjectCourse> _classesLT;
  late final Map<String, String> _teacherByIds;
  final RegExp _ltMatch = RegExp(r"/_LT$/");
  final RegExp _btMatch = RegExp(r"/\.[0-9]_BT$/");
  final dynamic input;
  TimetableData.from2dList(this.input) {
    if (input is! List) {
      throw Exception("input source is not 2d array");
    }
    timetable = [];
    _classesLT = {};
    _teacherByIds = {};
    Map<String, Map<String, dynamic>> tmpTkb = {};
    Map<String, Map<String, List<CourseTimeStamp>>> tmpTkbLT = {};
    // Map<String, List<ClassTimeStamp>> tmpClassesLT = {};

    for (List<String> mon in input) {
      String subjectID = mon[1];
      String name = mon[2];
      String classID = mon[3];
      String classRoom = mon[6];
      int dayOfWeek = 0;
      int classStamp = 0;
      int tin = int.parse(mon[7]);
      String teacherID = _teacherToID(mon[8]);

      if (!onlineClass.contains(classRoom)) {
        dayOfWeek = int.parse(mon[4]) - 1;
        classStamp = _toBits(mon[5]);
      }

      CourseTimeStamp stamp = CourseTimeStamp(
        intStamp: onlineClass.contains(classRoom) ? 0 : classStamp,
        dayOfWeek: dayOfWeek,
        classID: classID,
        teacherID: teacherID,
        room: classRoom,
        classType: onlineClass.contains(classRoom)
            ? ClassType.online
            : ClassType.offline,
      );

      if (_ltMatch.hasMatch(classID)) {
        classID = classID.replaceFirst(_ltMatch, '');
        if (!tmpTkbLT.containsKey(subjectID)) {
          tmpTkbLT[subjectID] = <String, List<CourseTimeStamp>>{};
        }
        if (!tmpTkbLT[subjectID]!.containsKey(classID)) {
          tmpTkbLT[subjectID]?[classID] = <CourseTimeStamp>[];
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
          "tin": tin,
          "classes": <String, List<CourseTimeStamp>>{},
        };
      }

      if (!tmpTkb[subjectID]?["classes"].containsKey(classID)) {
        tmpTkb[subjectID]?["classes"][classID] = <CourseTimeStamp>[];
      }
      tmpTkb[subjectID]?["classes"]?[classID].add(stamp);
    }

    tmpTkbLT.forEach((subjectID, classes) => classes
        .forEach((classID, timestamp) => _classesLT[classID] = SubjectCourse(
              subjectID: subjectID,
              classID: classID,
              timestamp: timestamp,
            )));

    // tmpClassesLT.forEach((classID, timestamp) => _classesLT[classID] = SubjectClass(
    //       subjectID: subjectID,
    //       classID: classID,
    //       timestamp: timestamp,
    //     ));

    tmpTkb.forEach((String subjectID, subjectInfo) => timetable.add(Subject(
          subjectID: subjectID,
          name: subjectInfo["name"].toString(),
          tin: subjectInfo["tin"],
          classes: _mapToClass(subjectID, subjectInfo["classes"]),
        )));
  }
  TimetableData.fromObject(this.input) {
    if (input is! Map<String, dynamic>) {
      throw Exception("input source is not JSON object");
    }

    Map<String, Map<String, dynamic>> tmpTkb = {};
    Map<String, Map<String, List<CourseTimeStamp>>> tmpTkbLT = {};

    input.forEach((subjectID, Map<String, dynamic> subjectInfo) {
      if (subjectInfo["classes"] is! Map<String, List>) {
        throw Exception("input source is not JSON object");
      }
      String name = subjectInfo["name"];
      String tin = subjectInfo["tin"];

      subjectInfo["classes"]
          ?.forEach((classID, List<Map<String, dynamic>> classInfo) {
        List<CourseTimeStamp> stampList = classInfo
            .map((stamp) => CourseTimeStamp(
                  intStamp: onlineClass.contains(stamp["room"])
                      ? 0
                      : _toBits(stamp["ca"]),
                  dayOfWeek: onlineClass.contains(stamp["room"])
                      ? 0
                      : (int.parse(stamp["dayOfWeek"]) - 1),
                  classID: classID,
                  teacherID: stamp['teacherID'],
                  room: stamp["room"],
                  classType: onlineClass.contains(stamp["room"])
                      ? ClassType.online
                      : ClassType.offline,
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
            "tin": tin,
            "classes": <String, List<CourseTimeStamp>>{},
          };
        }

        if (!tmpTkb[subjectID]?["classes"].containsKey(classID)) {
          tmpTkb[subjectID]?["classes"][classID] = <CourseTimeStamp>[];
        }
        tmpTkb[subjectID]?["classes"]?[classID] = stampList;
      });
    });

    tmpTkbLT.forEach((subjectID, classes) => classes
        .forEach((classID, timestamp) => _classesLT[classID] = SubjectCourse(
              subjectID: subjectID,
              classID: classID,
              timestamp: timestamp,
            )));

    tmpTkb.forEach((String subjectID, subjectInfo) => timetable.add(Subject(
          subjectID: subjectID,
          name: subjectInfo["name"].toString(),
          tin: subjectInfo["tin"],
          classes: _mapToClass(subjectID, subjectInfo["classes"]),
        )));
  }

  int _add0(int i, int n) => i << n;
  int _add1(int i, int n) => (i << (n + 1)) + (2 << n) - 1;

  int _toBits(String str) {
    if (str == "0-0") return 0;
    List<int> e = str.split("-").map(int.parse).toList(growable: false);
    return _add0(_add1(0, e[1] - e[0]), 13 - e[1]);
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
      String id, Map<String, List<CourseTimeStamp>> info) {
    List<SubjectCourse> tmpClasses = [];
    info.forEach((classID, timestamp) {
      if (_btMatch.hasMatch(id)) {
        classID = classID.replaceFirst(RegExp(r"/_BT$/"), '');
      }
      SubjectCourse tmpClass = SubjectCourse(
        subjectID: id,
        classID: classID,
        timestamp: timestamp,
      );
      if (_btMatch.hasMatch(id)) {
        tmpClass.mergeLT(_classesLT[id.replaceFirst(_btMatch, '')]);
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
