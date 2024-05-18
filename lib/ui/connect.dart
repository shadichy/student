import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student/core/configs.dart';
import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/study_plan.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/databases/subject_courses.dart';
import 'package:student/core/databases/subjects.dart';
import 'package:student/core/databases/teachers.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/ui/app.dart';
import 'package:student/ui/pages/init/loading.dart';
import 'package:student/ui/pages/init/main.dart';
import 'package:system_theme/system_theme.dart';

enum AppAction { init, reload, deinit }

class StudentApp extends StatefulWidget {
  const StudentApp({super.key});

  static void action(BuildContext context, AppAction action) {
    context.findAncestorStateOfType<_StudentAppState>()?.action(action);
  }

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  bool get initializeStart => SharedPrefs.getString("user") != null;

  // bool initializeStart = initStat;

  Widget mainContent = const Loading();

  Key key = UniqueKey();

  bool get useSystem =>
      AppConfig().getConfig<bool>("theme.systemTheme") == true;

  int? get colorCode => AppConfig().getConfig<int>("theme.accentColor");

  Color? get seed => useSystem
      ? SystemTheme.accentColor.accent
      : colorCode != null
          ? Color(colorCode!)
          : null;
  int get mode =>
      useSystem ? 0 : AppConfig().getConfig<int>("theme.themeMode") ?? 1;
  String? get font =>
      useSystem ? null : AppConfig().getConfig<String>("theme.appFont");

  void action(AppAction action) {
    setState(() {
      switch (action) {
        case AppAction.init:
          initialize();
          break;
        case AppAction.reload:
          // setConfigs();
          break;
        case AppAction.deinit:
          SharedPrefs.setString("user", null);
          Server.kill().then((_) {
            key = UniqueKey();
          });
          break;
      }
    });
  }

  // void setConfigs() {}

  @override
  void initState() {
    super.initState();
    initialize();
    // setConfigs();
  }

  Future<void> initialize() async {
    if (!initializeStart) return;
    await User().initialize();
    await SPBasics().initialize();
    await Teachers().initialize();
    await Subjects().initialize();
    await StudyPlan().initialize();
    await InStudyCourses().initialize();
    await SemesterTimetable().initialize();
    NotificationsGet().initialize();
    setState(() {
      mainContent = const App();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData buildTheme(Brightness brightness) {
      ColorScheme? colorScheme;
      if (seed is Color) {
        colorScheme = ColorScheme.fromSeed(
          seedColor: seed!,
          brightness: brightness,
        );
      }
      Color? bgColor = colorScheme?.primary.withOpacity(0.05);
      Color? textColor = colorScheme?.onSurface;
      ThemeData baseTheme = ThemeData(
        brightness: brightness,
        colorScheme: colorScheme,
        useMaterial3: true,
        splashColor: bgColor,
        hoverColor: bgColor,
        focusColor: bgColor,
        highlightColor: bgColor,
        // scaffoldBackgroundColor: colorScheme.surface,
        cardTheme: CardTheme(
          color: bgColor,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      return baseTheme.copyWith(
        textTheme: (font != null
                ? GoogleFonts.getTextTheme(font!, baseTheme.textTheme)
                : baseTheme.textTheme)
            .apply(
          displayColor: textColor,
          bodyColor: textColor,
        ),
      );
    }

    return KeyedSubtree(
      key: key,
      child: MaterialApp(
        title: 'Student',
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: ThemeMode.values[mode],
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: /* colorScheme.primary.withOpacity(0.08) */
                Colors.transparent,
            statusBarColor: Colors.transparent,
            // statusBarIconBrightness:
            //     Theme.of(context).brightness == Brightness.light
            //         ? Brightness.dark
            //         : Brightness.light,
          ),
          child: initializeStart ? mainContent : const Initializer(),
        ),
      ),
    );
  }
}
