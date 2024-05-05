import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/core/configs.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/user.dart';
// import 'package:student/core/databases/teachers.dart';
// import 'package:student/core/databases/subjects.dart';
// import 'package:student/core/databases/subject_courses.dart';
// import 'package:student/core/databases/study_plan.dart';
// import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/ui/app.dart';
import 'package:student/ui/connect.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:student/ui/pages/init/main.dart';
import 'package:system_theme/system_theme.dart';

class StudentApp extends StatefulWidget {
  const StudentApp({super.key});

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  bool initialized = SharedPrefs.getString("user") is String;

  Future<void> initialize() async {
    if (initialized) {
      await User().initialize();
      // await Teachers().initialize();
      // await Subjects().initialize();
      // await StudyPlan().initialize();
      // await InStudyCourses().initialize();
      // await SemesterTimetable().initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData buildTheme(Brightness brightness) {
      ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: AppConfig().getConfig<bool>("theme.systemTheme") == true
            ? SystemTheme.accentColor.accent
            : Color(
                AppConfig().getConfig<int>("theme.accentColor") ??
                    Colors.deepOrange.value,
              ),
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
        textTheme: baseTheme.textTheme.apply(
          displayColor: textColor,
          bodyColor: textColor,
        ),
      );
    }

    initialize();
    // m3SeededColor(baseTheme.colorScheme.primary);

    return MaterialApp(
      title: 'Student',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.values[
          AppConfig().getConfig<bool>("theme.systemTheme") == true
              ? 0
              : AppConfig().getConfig<int>("theme.themeMode") ?? 1],
      home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: /* colorScheme.primary.withOpacity(0.08) */
                Colors.transparent,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
          ),
          child: initialized ? const App() : const Initializer()),
      // home: const App(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SharedPrefs.initialize();
  await AppConfig().initialize();
  if (AppConfig().getConfig<bool>("theme.systemTheme") == true) {
    await SystemTheme.accentColor.load();
  }
  runApp(const RestartWidget(child: StudentApp()));
}
