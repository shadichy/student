import 'package:student/core/presets.dart';

enum ClassType { offline, online }

class CourseTimeStamp {
  final int intStamp;
  // late int startStamp;
  // late final int startStampUnix;
  // late int endStamp;
  // late final int endStampUnix;
  final int dayOfWeek;
  // late final String day;
  final String classID;
  final String teacherID;
  final String room;
  final ClassType classType;
  const CourseTimeStamp({
    required this.intStamp,
    required this.dayOfWeek,
    required this.classID,
    required this.teacherID,
    required this.room,
    required this.classType,
  });
}

class SubjectCourse {
  final String classID;
  final String subjectID;
  final List<CourseTimeStamp> timestamp;
  late final BigInt intCourse;
  late final int length;
  late final List<String> teachers;
  late final List<String> rooms;
  SubjectCourse({
    required this.classID,
    required this.subjectID,
    required this.timestamp,
  }) {
    length = timestamp.length;
    teachers = timestamp.map((m) => m.teacherID).toList();
    rooms = timestamp.map((m) => m.room).toList();
    intCourse = matrixIterate(timestamp);
  }

  static BigInt matrixIterate(List<CourseTimeStamp> stamps) {
    BigInt foldedStamp = BigInt.zero;
    for (CourseTimeStamp stamp in stamps) {
      foldedStamp |= (BigInt.from(stamp.intStamp) <<
          (stamp.dayOfWeek * classTimeStamps.length));
    }
    return foldedStamp;
  }

  void mergeLT(SubjectCourse? lt) {
    if (lt is! SubjectCourse) return;
    intCourse |= matrixIterate(lt.timestamp);
  }
}

class SubjectFilter {
  static final BigInt m01 = BigInt.parse("0x55555555555555555555555555555555");
  static final BigInt m02 = BigInt.parse("0x33333333333333333333333333333333");
  static final BigInt m04 = BigInt.parse("0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f");
  static final BigInt m08 = BigInt.parse("0x00ff00ff00ff00ff00ff00ff00ff00ff");
  static final BigInt m16 = BigInt.parse("0x0000ffff0000ffff0000ffff0000ffff");
  static final BigInt m32 = BigInt.parse("0x00000000ffffffff00000000ffffffff");
  static final BigInt m64 = BigInt.parse("0x0000000000000000ffffffffffffffff");
  static final BigInt h01 = BigInt.parse("0x01010101010101010101010101010101");

  static BigInt bigPopCount(BigInt x) {
    x -= (x >> 1) & m01;
    x = (x & m02) + ((x >> 2) & m02);
    x = (x + (x >> 4)) & m04;
    x += x >> 8;
    x += x >> 16;
    x += x >> 32;
    x += x >> 64;
    return x & BigInt.from(0x7f);
  }

  final List<String> inClass;
  final List<String> notInClass;
  final List<String> includeTeacher;
  final List<String> excludeTeacher;
  late int length;
  late final bool isEmpty;
  late final bool isNotEmpty;
  late final BigInt forcefulMatrix;
  late final BigInt spareMatrix;
  SubjectFilter({
    this.inClass = const [],
    this.notInClass = const [],
    this.includeTeacher = const [],
    this.excludeTeacher = const [],
    forcefulStamp = const [],
    spareStamp = const [],
  }) {
    length = 0;
    List<List> verifyList = [
      inClass,
      notInClass,
      includeTeacher,
      excludeTeacher,
      forcefulStamp,
      spareStamp,
    ];
    for (List property in verifyList) {
      if (property.isNotEmpty) {
        length++;
      }
    }
    isEmpty = length == 0;
    isNotEmpty = !isEmpty;
    forcefulMatrix = _fold(forcefulStamp);
    spareMatrix = _fold(spareStamp);
  }
  BigInt _fold(List<int> org) {
    return org.fold(
      BigInt.zero,
      (p, n) => (p << classTimeStamps.length) | BigInt.from(n),
    );
  }
}

class CompareStamp {
  final num delta;
  final SubjectCourse subjectClass;
  const CompareStamp({
    required this.delta,
    required this.subjectClass,
  });
}

class Subject {
  final String subjectID;
  final String? subjectAltID;
  final String name;
  final int tin;
  final List<SubjectCourse> classes;
  final List<String> dependencies;
  const Subject({
    required this.subjectID,
    this.subjectAltID,
    required this.name,
    required this.tin,
    required this.classes,
    // placeholer
    this.dependencies = const [],
  });

  Subject filter(SubjectFilter filterLayer) {
    if (filterLayer.isEmpty) {
      return this;
    }
    List<SubjectCourse> result = [];
    if (filterLayer.inClass.isNotEmpty) {
      result = classes
          .where((c) => filterLayer.inClass.contains(c.classID))
          .toList();
    }
    if (filterLayer.notInClass.isNotEmpty) {
      result = classes
          .where((c) => !filterLayer.notInClass.contains(c.classID))
          .toList();
    }
    if (filterLayer.includeTeacher.isNotEmpty) {
      List<CompareStamp> o = classes
          .map((c) => CompareStamp(
                delta: c.teachers.isEmpty
                    ? 0.0
                    : c.teachers
                            .where(
                                (t) => filterLayer.includeTeacher.contains(t))
                            .length /
                        c.teachers.length,
                subjectClass: c,
              ))
          .where((c) => c.delta != 0.0)
          .map((c) => CompareStamp(
                delta: ((c.delta - 1).abs() * 100),
                subjectClass: c.subjectClass,
              ))
          .toList();
      o.sort((a, b) => a.delta.compareTo(b.delta).toInt());
      result = o.map((c) => c.subjectClass).toList();
    }
    if (filterLayer.excludeTeacher.isNotEmpty) {
      result = classes
          .map((c) => CompareStamp(
                delta: c.teachers.isEmpty
                    ? 0.0
                    : c.teachers
                            .where(
                              (t) => filterLayer.excludeTeacher.contains(t),
                            )
                            .length /
                        c.teachers.length,
                subjectClass: c,
              ))
          .where((c) => c.delta == 0.0)
          .map((c) => c.subjectClass)
          .toList();
    }
    if (filterLayer.forcefulMatrix != BigInt.zero) {
      result = classes.where((c) {
        return c.intCourse & filterLayer.forcefulMatrix == BigInt.zero;
      }).toList();
    }
    if (filterLayer.spareMatrix != BigInt.zero) {
      List<CompareStamp> o = classes
          .map((c) => CompareStamp(
                delta: (c.intCourse & filterLayer.spareMatrix).toDouble(),
                subjectClass: c,
              ))
          .toList();
      o.sort((a, b) => SubjectFilter.bigPopCount(BigInt.from(a.delta))
          .compareTo(SubjectFilter.bigPopCount(BigInt.from(b.delta)))
          .toInt());
      result = o.map((c) => c.subjectClass).toList();
    }
    return Subject(subjectID: subjectID, name: name, tin: tin, classes: result);
  }
}
