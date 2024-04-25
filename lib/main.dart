import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:student/misc/misc_variables.dart';
import 'package:student/ui/pages/init/main.dart';

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
    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.red,
      brightness: Brightness.light,
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
    ThemeData buildTheme() {
      return baseTheme.copyWith(
          textTheme:
              // GoogleFonts.getTextTheme(
              //   "Varela Round",
              //   baseTheme.textTheme,
              // )
              baseTheme.textTheme.apply(
            displayColor: textColor,
            bodyColor: textColor,
          ),
          bottomNavigationBarTheme: baseTheme.bottomNavigationBarTheme.copyWith(
              backgroundColor: colorScheme.primary.withOpacity(0.08)));
    }

    initialize();
    m3SeededColor(baseTheme.colorScheme.primary);

    return MaterialApp(
      title: 'Student',
      theme: buildTheme(),
      home: initialized ? const App() : const Initializer(),
      // home: const App(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initialize();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const RestartWidget(child: StudentApp()));
}
