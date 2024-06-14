// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/navigator/home.dart';
import 'package:student/ui/navigator/school.dart';
import 'package:student/ui/navigator/student.dart';
import 'package:student/ui/navigator/timetable.dart';
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

final class _RouteNames {
  final program = "program";
  final major = "major";
  final student = "student";
  final decisions = "decisions";
  final finance = "finance";
  final learning_result = "learning_result";
  final status = "status";
  final timetable = "timetable";
  final notif = "notif";
  final papers = "papers";
  final search = "search";
  final about = "about";
  final misc_settings = "misc_settings";
  final notif_settings = "notif_settings";
  final settings = "settings";
  final themes = "themes";
  final upcoming = "upcoming";
  final generator = "generator";
  final help = "help";
}

abstract class Routing {
  static final routeNames = _RouteNames();

  static void goto(BuildContext context, Widget target) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => target,
    ));
  }

  static addRoute(String key, TypicalPage value) => _map[key] = value;

  static Map<String, TypicalPage> get allRoutes => _map;

  static TypicalPage? getRoute(String id) => _map[id];

  static List<TypicalPage> get mainNavigators => [
        const HomePage(),
        TimetablePage(),
        SchoolPage(),
        StudentPage(),
      ];

  static final Map<String, TypicalPage> _map = {
    routeNames.program: const InfoEduProgramPage(),
    routeNames.major: const InfoMajorPage(),
    routeNames.student: const InfoStudentPage(),
    routeNames.decisions: const InfoStudentDecisionsPage(),
    routeNames.finance: const LearningFinance(),
    routeNames.learning_result: const LearningResultPage(),
    routeNames.status: const LearningStatusPage(),
    routeNames.timetable: const LearningTimetablePage(),
    routeNames.notif: const NotificationPage(),
    routeNames.papers: const SchoolNewPapersPage(),
    routeNames.search: const SearchPage(),
    routeNames.about: const SettingsAboutPage(),
    routeNames.misc_settings: const SettingsMiscPage(),
    routeNames.notif_settings: const SettingsNotificationsPage(),
    routeNames.settings: const SettingsPage(),
    routeNames.themes: const SettingsThemesPage(),
    routeNames.upcoming: const SubjectUpComingEventPage(),
    routeNames.generator: const ToolsTimetableGeneratorPage(),
    routeNames.help: const HelpMDViewerPage(),
  };

  static TypicalPage get program => _map[routeNames.program]!;
  static TypicalPage get major => _map[routeNames.major]!;
  static TypicalPage get student => _map[routeNames.student]!;
  static TypicalPage get decisions => _map[routeNames.decisions]!;
  static TypicalPage get finance => _map[routeNames.finance]!;
  static TypicalPage get learning_result => _map[routeNames.learning_result]!;
  static TypicalPage get status => _map[routeNames.status]!;
  static TypicalPage get timetable => _map[routeNames.timetable]!;
  static TypicalPage get notif => _map[routeNames.notif]!;
  static TypicalPage get papers => _map[routeNames.papers]!;
  static TypicalPage get search => _map[routeNames.search]!;
  static TypicalPage get about => _map[routeNames.about]!;
  static TypicalPage get misc_settings => _map[routeNames.misc_settings]!;
  static TypicalPage get notif_settings => _map[routeNames.notif_settings]!;
  static TypicalPage get settings => _map[routeNames.settings]!;
  static TypicalPage get themes => _map[routeNames.themes]!;
  static TypicalPage get upcoming => _map[routeNames.upcoming]!;
  static TypicalPage get generator => _map[routeNames.generator]!;
  static TypicalPage get help => _map[routeNames.help]!;

  static TypicalPage Function(SubjectCourse) get course =>
      (p) => SubjectCoursePage(p);
  static TypicalPage Function(CourseTimestamp) get stamp =>
      (p) => SubjectStampPage(p);
  static TypicalPage Function(Subject) get subject => (p) => SubjectPage(p);
  static Widget Function(String) get search_result =>
      (p) => SearchResultPage(p);
  static Widget Function(int) get notif_detail =>
      (p) => const NotificationDetailPage();
  static Widget Function(String) get article => (p) => SchoolArticlePage(p);
  static Widget Function(String) get quick_action_edit =>
      (p) => SettingsQuickActionPage(p);
}
