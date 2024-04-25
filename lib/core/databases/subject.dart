class BaseSubject {
  final String subjectID;
  final String subjectAltID;
  final String name;
  final int cred;
  // final List<SubjectCourse> courses;
  final List<String> dependencies;
  const BaseSubject({
    required this.subjectID,
    required this.subjectAltID,
    required this.name,
    required this.cred,
    // required this.courses,
    required this.dependencies,
  });

  // SubjectCourse? getCourse(String courseID) {
  //   return courses.firstWhere(
  //     (SubjectCourse course) => course.classID == courseID,
  //   );
  // }
}
