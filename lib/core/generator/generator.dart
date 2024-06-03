import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/semester/functions.dart';

class SampleTimetable {
  final List<SubjectCourse> classes;
  final BigInt intMatrix;
  final int length;
  SampleTimetable({required this.classes})
      : length = classes.length,
        intMatrix = classes.fold(BigInt.zero, (f, i) => f = i.intCourse);
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
      (p, n) => (p << SPBasics().classTimestamps.length) | BigInt.from(n),
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

extension Filter on Subject {
  Subject filter(SubjectFilter filterLayer) {
    if (filterLayer.isEmpty) {
      return this;
    }
    List<SubjectCourse> result = [];
    if (filterLayer.inClass.isNotEmpty) {
      result = courses.values
          .where((c) => filterLayer.inClass.contains(c.courseID))
          .toList();
    }
    if (filterLayer.notInClass.isNotEmpty) {
      result = courses.values
          .where((c) => !filterLayer.notInClass.contains(c.courseID))
          .toList();
    }
    if (filterLayer.includeTeacher.isNotEmpty) {
      List<CompareStamp> o = courses.values
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
      result = courses.values
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
      result = courses.values.where((c) {
        return c.intCourse & filterLayer.forcefulMatrix == BigInt.zero;
      }).toList();
    }
    if (filterLayer.spareMatrix != BigInt.zero) {
      List<CompareStamp> o = courses.values
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
    return Subject(
      subjectID: subjectID,
      name: name,
      cred: cred,
      coef: coef,
      courses: result.asMap().map((_, v) => MapEntry(v.courseID, v)),
      subjectAltID: subjectID,
      dependencies: [],
    );
  }
}

class GenTimetable {
  final List<Subject> _tkb;
  late final Map<String, SubjectFilter> _input;
  late List<SampleTimetable> output = [];
  late BigInt intMatrix = BigInt.zero;
  late int length = 0;
  GenTimetable(this._tkb, this._input) {
    _input.forEach((key, value) => _generate(key, value));
  }

  void _generate(String key, SubjectFilter filterLayer) {
    Subject filteredSubject =
        _tkb.firstWhere((subj) => subj.subjectID == key).filter(filterLayer);
    if (output.isEmpty) {
      output.addAll(filteredSubject.courses.values
          .map((c) => SampleTimetable(classes: [c])));
    } else {
      List<SampleTimetable> newOutput = [];
      for (SampleTimetable sample in output) {
        for (SubjectCourse target in filteredSubject.courses.values) {
          BigInt tmpDint = BigInt.zero;
          tmpDint = sample.intMatrix & target.intCourse;
          if (tmpDint != BigInt.zero) continue;
          newOutput.add(SampleTimetable(classes: sample.classes + [target]));
        }
      }
      output = newOutput;
    }
  }

  GenTimetable add(Map<String, SubjectFilter> subj) {
    subj.forEach((key, value) {
      _input[key] = value;
      _generate(key, value);
    });
    return this;
  }

  SubjectFilter? remove(String key) {
    SubjectFilter? value = _input.remove(key);
    output = [];
    _input.forEach((key, value) => _generate(key, value));
    return value;
  }

  bool unsave(SampleTimetable sample) => output.remove(sample);

  GenTimetable operator +(Map<String, SubjectFilter> subj) => add(subj);
  SubjectFilter? operator -(String key) => remove(key);
}
