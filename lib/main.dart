import 'dart:convert';

import 'package:flutter/material.dart';
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

  static void action(BuildContext context, AppAction action) {
    context.findAncestorStateOfType<_StudentAppState>()?.action(action);
  }

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  bool initialized = SharedPrefs.getString("user") is String;

  Key key = UniqueKey();

  static dynamic getter<T>(String g, T defaultValue) =>
      jsonDecode(SharedPrefs.getString("config") ?? "{}")[g] ?? defaultValue;

  Color color = getter("theme.colorPalette", Colors.red.value);

  void action(AppAction action) {
    setState(() {
      switch (action) {
        case AppAction.init:
          initialized = SharedPrefs.getString("user") is String;
          break;
        case AppAction.reload:
          color = getter<int>("theme.colorPalette", Colors.red.value);
          break;
      }
    });
  }

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

  ThemeData buildTheme(Color color) {
    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: color,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    initialize();
    m3SeededColor(buildTheme(color).colorScheme.primary);

    return KeyedSubtree(
      key: key,
      child: MaterialApp(
        title: 'Student',
        theme: buildTheme(color),
        home: initialized ? const App() : const Initializer(),
        // home: const App(),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initialize();
  runApp(const RestartWidget(child: StudentApp()));
}
