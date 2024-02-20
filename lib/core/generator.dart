import 'package:student/core/functions.dart';

class BaseTimetable {
  final List<SubjectClass> classes;
  late final List<int> intMatrix;
  late final int length;
  BaseTimetable({required this.classes}) {
    length = classes.length;
    intMatrix = [0, 0, 0, 0, 0, 0, 0];
    for (SubjectClass c in classes) {
      for (int i = 0; i < 7; i++) {
        intMatrix[i] |= c.intMatrix[i];
      }
    }
  }
}

class GenTimetable {
  final List<Subject> _tkb;
  late final Map<String, SubjectFilter> _input;
  late List<BaseTimetable> output = [];
  late List<int> intMatrix = [0, 0, 0, 0, 0, 0, 0];
  late int length = 0;
  GenTimetable(this._tkb, this._input) {
    _input.forEach((key, value) => _generate(key, value));
  }

  void _generate(String key, SubjectFilter filterLayer) {
    Subject filteredSubject =
        _tkb.firstWhere((subj) => subj.subjectID == key).filter(filterLayer);
    if (output.isEmpty) {
      output
          .addAll(filteredSubject.classes.map((c) => BaseTimetable(classes: [c])));
    } else {
      List<BaseTimetable> newOutput = [];
      for (BaseTimetable sample in output) {
        for (SubjectClass target in filteredSubject.classes) {
          List<int> tmpDint = [0, 0, 0, 0, 0, 0, 0];
          for (int i = 0; i < 7; i++) {
            tmpDint[i] = sample.intMatrix[i] & target.intMatrix[i];
          }
          if (tmpDint.fold(0, (a, b) => a + b) == 0) {
            newOutput.add(BaseTimetable(classes: sample.classes + [target]));
          }
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

  bool unsave(BaseTimetable sample) => output.remove(sample);

  GenTimetable operator +(Map<String, SubjectFilter> subj) => add(subj);
  SubjectFilter? operator -(String key) => remove(key);
}
