import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/semester/functions.dart';

class SampleTimetable {
  final List<SubjectCourse> classes;
  final BigInt intMatrix;
  int get length => classes.length;

  SampleTimetable({required this.classes})
      : intMatrix = classes.fold(BigInt.zero, (f, i) => f = i.intCourse);
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

  static BigInt fold(List<int> org) {
    return org.fold(
      BigInt.zero,
      (p, n) => (p << SPBasics().classTimestamps.length) | BigInt.from(n),
    );
  }

  List<String> inClass;
  List<String> notInClass;
  List<String> includeTeacher;
  List<String> excludeTeacher;
  BigInt forcefulMatrix;
  BigInt spareMatrix;

  int get length => [inClass, notInClass, includeTeacher, excludeTeacher]
      .where((l) => l.isNotEmpty)
      .length;

  bool get isEmpty => length == 0;

  bool get isNotEmpty => !isEmpty;

  SubjectFilter({
    this.inClass = const [],
    this.notInClass = const [],
    this.includeTeacher = const [],
    this.excludeTeacher = const [],
    BigInt? forcefulMatrix,
    BigInt? spareMatrix,
  })  : forcefulMatrix = forcefulMatrix ?? BigInt.zero,
        spareMatrix = spareMatrix ?? BigInt.zero;
}

extension Filter on Subject {
  Subject filter(SubjectFilter? filterLayer) {
    if (filterLayer == null || filterLayer.isEmpty) return this;

    Iterable<SubjectCourse> result = courses.values;

    if (filterLayer.inClass.isNotEmpty) {
      result = result.where((c) => filterLayer.inClass.contains(c.courseID));
    }

    if (filterLayer.notInClass.isNotEmpty) {
      result =
          result.where((c) => !filterLayer.notInClass.contains(c.courseID));
    }

    if (filterLayer.includeTeacher.isNotEmpty) {
      Set<String> includeTeachers = filterLayer.includeTeacher.toSet();
      num toComparable(SubjectCourse c) =>
          c.teachers.toSet().intersection(includeTeachers).length /
          c.teachers.length;

      result = (result.where((c) => c.teachers.isNotEmpty).toList()
        ..sort((a, b) => toComparable(b).compareTo(toComparable(a))));
    }

    if (filterLayer.excludeTeacher.isNotEmpty) {
      result = result
          .where((c) => !c.teachers.any(filterLayer.excludeTeacher.contains));
    }

    if (filterLayer.forcefulMatrix != BigInt.zero) {
      result = result.where(
          (c) => c.intCourse & filterLayer.forcefulMatrix == BigInt.zero);
    }

    if (filterLayer.spareMatrix != BigInt.zero) {
      BigInt toComparable(SubjectCourse c) =>
          SubjectFilter.bigPopCount(c.intCourse & filterLayer.spareMatrix);

      result = (result.toList()
        ..sort((a, b) => toComparable(a).compareTo(toComparable(b))));
    }

    return Subject(
      subjectID: subjectID,
      name: name,
      cred: cred,
      coef: coef,
      courses: Map.fromEntries(result.map((v) => MapEntry(v.courseID, v))),
      subjectAltID: subjectID,
      dependencies: [],
    );
  }
}

final class GenTimetable {
  final Map<String, Subject> subjectData;

  const GenTimetable(this.subjectData);

  GenResult generate(Map<String, SubjectFilter?> from) => GenResult([],
      from.entries.map((e) => subjectData[e.key]!.filter(e.value)).toList());
}

class GenResult {
  final List<Subject> genData;
  final List<SampleTimetable> output;
  GenResult(List<SampleTimetable> input, this.genData)
      : output = _init(input, genData);

  int get length => output.length;

  static List<SampleTimetable> _init(
    List<SampleTimetable> input,
    List<Subject> genData,
  ) {
    if (input.isEmpty) {
      input.addAll(genData.removeAt(0).courses.values.map((c) {
        return SampleTimetable(classes: [c]);
      }));
    }

    return genData.fold(input, (prevSamples, subject) {
      List<SampleTimetable> newOutput = [];
      for (var sample in prevSamples) {
        for (var target in subject.courses.values) {
          if (sample.intMatrix & target.intCourse != BigInt.zero) continue;
          newOutput.add(SampleTimetable(classes: sample.classes..add(target)));
        }
      }
      return newOutput;
    });
  }

  GenResult add(List<Subject> subjects) => GenResult(output, subjects);
}

class _GenTimetable {
  final List<Subject> _tkb;
  late final Map<String, SubjectFilter> _input;
  late List<SampleTimetable> output = [];
  late BigInt intMatrix = BigInt.zero;
  late int length = 0;

  _GenTimetable(this._tkb, this._input) {
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
      for (var sample in output) {
        for (var target in filteredSubject.courses.values) {
          BigInt tmpDint = BigInt.zero;
          tmpDint = sample.intMatrix & target.intCourse;
          if (tmpDint != BigInt.zero) continue;
          newOutput.add(SampleTimetable(classes: sample.classes + [target]));
        }
      }
      output = newOutput;
    }
  }

  _GenTimetable add(Map<String, SubjectFilter> subj) {
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

  _GenTimetable operator +(Map<String, SubjectFilter> subj) => add(subj);

  SubjectFilter? operator -(String key) => remove(key);
}
