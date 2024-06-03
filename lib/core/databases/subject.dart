import 'package:hive/hive.dart';
part 'subject.g.dart';

@HiveType(typeId: 0)
class BaseSubject {
  @HiveField(0)
  final String subjectID;
  @HiveField(1)
  final String? subjectAltID;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final int cred;
  // final List<SubjectCourse> courses;
  @HiveField(4)
  final List<String> dependencies;
  @HiveField(5)
  final double coef;
  const BaseSubject({
    required this.subjectID,
    this.subjectAltID,
    required this.name,
    required this.cred,
    required this.coef,
    // required this.courses,
    required this.dependencies,
  });

  BaseSubject.fromJson(Map<String, dynamic> data, [String? subjectID])
      : this(
          subjectID: subjectID ?? data["subjectID"] as String,
          subjectAltID: data["subjectAltID"] as String?,
          name: data["name"] as String,
          cred: data["cred"] as int,
          coef: data["coef"] is int
              ? (data["coef"] as int).toDouble()
              : data["coef"] as double? ?? 1,
          dependencies: (data["dependencies"] as List).cast(),
        );

  // SubjectCourse? getCourse(String courseID) {
  //   return courses.firstWhereIf(
  //     (SubjectCourse course) => course.classID == courseID,
  //   );
  // }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'subjectID': subjectID,
        'subjectAltID': subjectAltID,
        'name': name,
        'cred': cred,
        'dependencies': dependencies,
      };

  @override
  String toString() => toMap.toString();
}
