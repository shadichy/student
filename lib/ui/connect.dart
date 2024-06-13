import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/notification/alarm.dart';
import 'package:student/core/notification/model/alarm_settings.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/app.dart';
import 'package:student/ui/pages/init/loading.dart';
import 'package:student/ui/pages/init/main.dart';
import 'package:student/ui/pages/subject/stamp_intent.dart';
import 'package:system_theme/system_theme.dart';

enum AppAction { init, reload, deinit }

class StudentApp extends StatefulWidget {
  final String initialRoute;
  final Map<String, dynamic> arguments;

  const StudentApp(this.initialRoute, this.arguments, {super.key});

  static void action(BuildContext context, AppAction action) {
    context.findAncestorStateOfType<_StudentAppState>()?.action(action);
  }

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  late final Map<String, dynamic>? arguments;
  // static bool get start => SharedPrefs.getString("user") != null;
  static bool get start => Storage().getUser() != null;
  bool initializeStart = start;

  // bool initializeStart = initStat;

  Widget mainContent = const Loading();

  Key key = UniqueKey();

  bool get useSystem => Storage().fetch<bool>("theme.systemTheme") == true;

  int? get colorCode => Storage().fetch<int>("theme.accentColor");

  Color? get seed => useSystem
      ? SystemTheme.accentColor.accent
      : colorCode != null
          ? Color(colorCode!)
          : null;
  int get mode => useSystem ? 0 : Storage().fetch<int>("theme.themeMode") ?? 1;
  String? get font =>
      useSystem ? null : Storage().fetch<String>("theme.appFont");

  static StreamSubscription<AlarmSettings>? subscription;
  static const platform = MethodChannel("dev.tlu.student.methods");

  void action(AppAction action) {
    setState(() {
      switch (action) {
        case AppAction.init:
        case AppAction.reload:
        case AppAction.deinit:
          break;
      }
    });
  }

  // void setConfigs() {}

  @override
  void initState() {
    super.initState();
    arguments = widget.arguments;
    initialize();
    // setConfigs();
  }

  Future<void> initialize() async {
    if (!initializeStart) return;

    await User().initialize();
    // await SPBasics().initialize();
    // await Teachers().initialize();
    // await Subjects().initialize();
    // await StudyPlan().initialize();
    // await InStudyCourses().initialize();
    // await SemesterTimetable().initialize();
    // NotificationsGet().initialize();
    // User().setUser(Storage().getUser()!);
    await Storage().initialize();
    // print("Running");

    // print(Storage().getUser());
    // print(Storage().planTable);
    // print(Storage().thisWeek.toJson());
    subscription ??= Alarm.ringStream.stream.listen(doRing);

    setState(() {
      // mainContent = const App();
      try {
        mainContent = <String, Widget>{
          '/': const App(),
          '/alarm': SubjectStampIntent(widget.arguments["id"] ?? -1),
        }[widget.initialRoute]!;
      } catch (e, s) {
        alarmPrint(e.toString());
        alarmPrint(s.toString());
      }
    });
  }

  Future<void> doRing(AlarmSettings alarmSettings) async {
    // invoke method alarm
    try {
      await platform.invokeMethod("alarm", {
        "id": alarmSettings.id,
      });
    } on PlatformException catch (e) {
      alarmPrint(e.message);
      alarmPrint(e.stacktrace);
    }
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) await Permission.notification.request();
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) await Permission.storage.request();
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) await Permission.scheduleExactAlarm.request();
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

    if (arguments?["route"] != null) {
      try {
        Routing.goto(context, Routing.getRoute(arguments?["route"])!);
      } catch (e) {
        //   route not found
      }
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
