
// @Deprecated("moving to Hive")
// final class InStudyCourses {
//   InStudyCourses._instance();
//   static final _inStudyCoursesInstance = InStudyCourses._instance();
//   factory InStudyCourses() {
//     return _inStudyCoursesInstance;
//   }

//   late final Iterable<Subject> _inStudyCourses;
//   String _getCourseID(String id) => RegExp(r'([^.]+)').firstMatch(id)![0]!;

//   Subject? getSubject(String id) =>
//       _inStudyCourses.firstWhereIf((s) => s.subjectID == id);

//   Subject? getSubjectAlt(String id) =>
//       _inStudyCourses.firstWhereIf((s) => s.subjectAltID == _getCourseID(id));

//   SubjectCourse? getCourse(String id) {
//     try {
//       return getSubjectAlt(_getCourseID(id))?.getCourse(id);
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<void> initialize() async {
//     Map<String, dynamic> rawInfo =
//         await Server.getSemester(User().group, User().semester);

//     // Map<String, List<Map<String, dynamic>>> parsedInfo = {};
//     // throw Exception("d log1");

//     // parsedInfo = rawInfo.map((key, value) =>
//     // MapEntry(key, MiscFns.listType<Map<String, dynamic>>(value as List)));

//     _inStudyCourses = rawInfo.map<String, Subject>((key, value) {
//       BaseSubject? s = Subjects().getSubject(key);
//       if (s! is Subject) {
//         throw Exception(
//             "Failed to parse inStudyCourses info JSON: $key is invalid!");
//       }

//       Iterable<SubjectCourse> map = (value as List).map<SubjectCourse>((c) {
//         String courseID = c["courseID"] as String;

//         SubjectCourse course = SubjectCourse(
//           courseID: courseID,
//           subjectID: s.subjectID,
//           timestamp: (c["timestamp"] as List).map<CourseTimestamp>(
//             (s) {
//               CourseTimestamp stamp = CourseTimestamp.fromJson(
//                 s as Map<String, dynamic>,
//                 courseID,
//               );
//               // Routing.addRoute(
//               //   "stamp_${courseID}_${stamp.dayOfWeek}_${stamp.intStamp}",
//               //   Routing.stamp(stamp),
//               // );

//               return stamp;
//             },
//           ).toList(),
//         );

//         // Routing.addRoute("course_$courseID", Routing.course(course));

//         return course;
//       });

//       Subject subject = Subject.fromBase(
//         s,
//         map.toList().asMap().map((_, v) => MapEntry(v.courseID, v)),
//       );

//       // Routing.addRoute("subject_$s", Routing.subject(subject));

//       return MapEntry(key, subject);
//     }).values;
//   }
// }
