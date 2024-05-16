import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student/core/configs.dart';
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
  static bool get initStat => SharedPrefs.getString("user") != null;

  bool initializeStart = initStat;

  Widget mainContent = const Loading();

  Key key = UniqueKey();

  late Color seed;
  late int mode;
  late String? font;

  void action(AppAction action) {
    setState(() {
      switch (action) {
        case AppAction.init:
          initializeStart = initStat;
          initialize();
          break;
        case AppAction.reload:
          setTheme();
          break;
        case AppAction.deinit:
          SharedPrefs.setString("user", null);
          initializeStart = false;
          key = UniqueKey();
          break;
      }
    });
  }

  void setTheme() {
    bool useSystem = AppConfig().getConfig<bool>("theme.systemTheme") == true;
    seed = useSystem
        ? SystemTheme.accentColor.accent
        : Color(AppConfig().getConfig<int>("theme.accentColor") ??
            Colors.deepOrange.value);
    mode = useSystem ? 0 : AppConfig().getConfig<int>("theme.themeMode") ?? 1;
    font = useSystem ? null : AppConfig().getConfig<String>("theme.appFont");
  }

  @override
  void initState() {
    super.initState();
    initialize();
    setTheme();
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
    await NotificationsGet().initialize();
    setState(() => mainContent = const App());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData buildTheme(Brightness brightness) {
      ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
      );
      Color bgColor = colorScheme.primary.withOpacity(0.05);
      Color textColor = colorScheme.onSurface;
      ThemeData baseTheme = ThemeData(
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
