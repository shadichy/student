// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/navigator/home.dart';
import 'package:student/ui/navigator/timetable.dart';
import 'package:student/ui/navigator/school.dart';
import 'package:student/ui/navigator/student.dart';
import 'package:student/ui/pages/help/mdviewer.dart';
import 'package:student/ui/pages/info/edu_program.dart';
import 'package:student/ui/pages/info/major.dart';
import 'package:student/ui/pages/info/student.dart';
import 'package:student/ui/pages/info/student_decisions.dart';
// import 'package:student/ui/pages/init/main.dart';
import 'package:student/ui/pages/learning/finance.dart';
import 'package:student/ui/pages/learning/result.dart';
import 'package:student/ui/pages/learning/status.dart';
import 'package:student/ui/pages/learning/timetable.dart';
import 'package:student/ui/pages/notification/detail.dart';
import 'package:student/ui/pages/notification/notification.dart';
import 'package:student/ui/pages/school/article.dart';
import 'package:student/ui/pages/school/new_papers.dart';
// import 'package:student/ui/pages/notification/preview.dart';
import 'package:student/ui/pages/search/result.dart';
import 'package:student/ui/pages/search/search.dart';
import 'package:student/ui/pages/settings/about.dart';
import 'package:student/ui/pages/settings/misc.dart';
import 'package:student/ui/pages/settings/notifications.dart';
import 'package:student/ui/pages/settings/quick_action.dart';
import 'package:student/ui/pages/settings/settings.dart';
import 'package:student/ui/pages/settings/themes.dart';
import 'package:student/ui/pages/subject/course.dart';
// import 'package:student/ui/pages/subject/course_preview.dart';
import 'package:student/ui/pages/subject/stamp.dart';
import 'package:student/ui/pages/subject/subject.dart';
import 'package:student/ui/pages/subject/upcoming_event.dart';
import 'package:student/ui/pages/tools/timetable_generator.dart';

abstract class Routing {
  static void goto(BuildContext context, Widget target) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => target,
    ));
  }

  static addRoute(String key, TypicalPage value) => _map[key] = value;

  static Map<String, TypicalPage> get allRoutes => _map;

  static TypicalPage? getRoute(String id) => _map[id];

  static List<TypicalPage> get mainNavigators => [
        HomePage(),
        TimetablePage(),
        SchoolPage(),
        StudentPage(),
      ];

  static final Map<String, TypicalPage> _map = {
    'program': const InfoEduProgramPage(),
    'major': const InfoMajorPage(),
    'student': const InfoStudentPage(),
    'decisions': const InfoStudentDecisionsPage(),
    'finance': const LearningFinance(),
    'learning_result': const LearningResultPage(),
    'status': const LearningStatusPage(),
    'timetable': const LearningTimetablePage(),
    'notif': const NotificationPage(),
    'papers': const SchoolNewPapersPage(),
    'search': const SearchPage(),
    'about': const SettingsAboutPage(),
    'misc_settings': const SettingsMiscPage(),
    'notif_settings': const SettingsNotificationsPage(),
    'settings': const SettingsPage(),
    'themes': const SettingsThemesPage(),
    'upcoming': const SubjectUpComingEventPage(),
    'generator': const ToolsTimetableGeneratorPage(),
    'help': const HelpMDViewerPage(),
  };

  static TypicalPage get program => _map['program']!;
  static TypicalPage get major => _map['major']!;
  static TypicalPage get student => _map['student']!;
  static TypicalPage get decisions => _map['decisions']!;
  static TypicalPage get finance => _map['finance']!;
  static TypicalPage get learning_result => _map['learning_result']!;
  static TypicalPage get status => _map['status']!;
  static TypicalPage get timetable => _map['timetable']!;
  static TypicalPage get notif => _map['notif']!;
  static TypicalPage get papers => _map['papers']!;
  static TypicalPage get search => _map['search']!;
  static TypicalPage get about => _map['about']!;
  static TypicalPage get misc_settings => _map['misc_settings']!;
  static TypicalPage get notif_settings => _map['notif_settings']!;
  static TypicalPage get settings => _map['settings']!;
  static TypicalPage get themes => _map['themes']!;
  static TypicalPage get upcoming => _map['upcoming']!;
  static TypicalPage get generator => _map['generator']!;
  static TypicalPage get help => _map['help']!;

  static TypicalPage Function(SubjectCourse) get course =>
      (_) => SubjectCoursePage(_);
  static TypicalPage Function(CourseTimestamp) get stamp =>
      (_) => SubjectStampPage(_);
  static TypicalPage Function(Subject) get subject => (_) => SubjectPage(_);
  static Widget Function(String) get search_result =>
      (_) => SearchResultPage(_);
  static Widget Function(int) get notif_detail =>
      (_) => const NotificationDetailPage();
  static Widget Function(String) get article => (_) => SchoolArticlePage(_);
  static Widget Function(String) get quick_action_edit =>
      (_) => SettingsQuickActionPage(_);
}
