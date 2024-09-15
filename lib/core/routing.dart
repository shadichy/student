// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
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
import 'package:student/ui/pages/learning/finance.dart';
import 'package:student/ui/pages/learning/result.dart';
import 'package:student/ui/pages/learning/status.dart';
import 'package:student/ui/pages/learning/timetable.dart';
import 'package:student/ui/pages/notification/detail.dart';
import 'package:student/ui/pages/notification/event.dart';
import 'package:student/ui/pages/notification/notification.dart';
import 'package:student/ui/pages/school/article.dart';
import 'package:student/ui/pages/school/new_papers.dart';
import 'package:student/ui/pages/search/result.dart';
import 'package:student/ui/pages/search/search.dart';
import 'package:student/ui/pages/settings/about.dart';
import 'package:student/ui/pages/settings/misc.dart';
import 'package:student/ui/pages/settings/notifications.dart';
import 'package:student/ui/pages/settings/quick_action.dart';
import 'package:student/ui/pages/settings/reminders.dart';
import 'package:student/ui/pages/settings/settings.dart';
import 'package:student/ui/pages/settings/themes.dart';
import 'package:student/ui/pages/subject/course.dart';
import 'package:student/ui/pages/subject/stamp.dart';
import 'package:student/ui/pages/subject/subject.dart';
import 'package:student/ui/pages/subject/upcoming_event.dart';
import 'package:student/ui/pages/tools/course_selector.dart';
import 'package:student/ui/pages/tools/generated_timetable_preview.dart';
import 'package:student/ui/pages/tools/generator_instance.dart';
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
  final reminders = "reminders";
  final settings = "settings";
  final themes = "themes";
  final upcoming = "upcoming";
  final generator = "generator";
  final generator_instance = "generator_instance";
  final course_selector = "course_selector";
  final help = "help";
}

abstract final class Routing {
  static final names = _RouteNames();

  static Future<T?> goto<T>(
    BuildContext context,
    Widget target,
  ) async {
    return await Navigator.push(
      context,
      MaterialPageRoute<T>(builder: (_) => target),
    );
  }

  static addRoute(String key, TypicalPage value) => _map[key] = value;

  static Map<String, TypicalPage> get allRoutes => _map;

  static TypicalPage? getRoute(String id) => _map[id];

  static List<TypicalPage> get mainNavigators => _navigators;

  static const List<TypicalPage> _navigators = [
    HomePage(),
    TimetablePage(),
    SchoolPage(),
    StudentPage(),
  ];

  static final Map<String, TypicalPage> _map = {
    names.program: program,
    names.major: major,
    names.student: student,
    names.decisions: decisions,
    names.finance: finance,
    names.learning_result: learning_result,
    names.status: status,
    names.timetable: timetable,
    names.notif: notif,
    names.papers: papers,
    names.search: search,
    names.about: about,
    names.misc_settings: misc_settings,
    names.notif_settings: notif_settings,
    names.reminders: reminders,
    names.settings: settings,
    names.themes: themes,
    names.upcoming: upcoming,
    names.generator: generator,
    names.course_selector: course_selector,
    names.help: help,
  };

  static const program = InfoEduProgramPage();
  static const major = InfoMajorPage();
  static const student = InfoStudentPage();
  static const decisions = InfoStudentDecisionsPage();
  static const finance = LearningFinance();
  static const learning_result = LearningResultPage();
  static const status = LearningStatusPage();
  static const timetable = LearningTimetablePage();
  static const notif = NotificationPage();
  static const papers = SchoolNewPapersPage();
  static const search = SearchPage();
  static const about = SettingsAboutPage();
  static const misc_settings = SettingsMiscPage();
  static const notif_settings = SettingsNotificationsPage();
  static const reminders = SettingsRemindersPage();
  static const settings = SettingsPage();
  static const themes = SettingsThemesPage();
  static const upcoming = SubjectUpcomingEventPage();
  static const generator = ToolsTimetableGeneratorPage();
  static const course_selector = ToolsCourseSelectorPage();
  static const help = HelpMDViewerPage();

  static const course = SubjectCoursePage.new;
  static const stamp = SubjectStampPage.new;
  static const subject = SubjectPage.new;
  static const event = NotificationEventPage.new;
  static const search_result = SearchResultPage.new;
  static const notification_detail = NotificationDetailPage.new;
  static const article = SchoolArticlePage.new;
  static const quick_action_edit = SettingsQuickActionPage.new;
  static const generator_instance = ToolsGeneratorInstancePage.new;
  static const generated_timetable_preview = ToolsGeneratedTimetablePreview.new;
}
