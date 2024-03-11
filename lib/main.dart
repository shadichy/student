import 'package:flutter/material.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/ui/app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student/misc/misc_variables.dart';
import 'package:student/ui/pages/init/main.dart';

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

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
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardTheme(
        // color: bgColor,
        // margin: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
    ThemeData buildTheme() {
      return baseTheme.copyWith(
        textTheme: GoogleFonts.getTextTheme(
          "Varela Round",
          baseTheme.textTheme,
        ).apply(
          displayColor: textColor,
          bodyColor: textColor,
        ),
      );
    }

    m3SeededColor(baseTheme.colorScheme.primary);
    return MaterialApp(
      title: 'Student',
      theme: buildTheme(),
      home: User.initialized ? const App() : const Initializer(),
    );
  }
}

void main() async {
  await SharedPrefs.initialize();
  runApp(const StudentApp());
}
