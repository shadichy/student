import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/ui/connect.dart';
import 'package:student/ui/pages/subject/stamp_intent.dart';
import 'package:system_theme/system_theme.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Storage().register();
  if (Storage().fetch<bool>(Config.theme.systemTheme) == true) {
    await SystemTheme.accentColor.load();
  }
  // await NotificationService().initialize();
  Map<String, dynamic> argMap = jsonDecode(args.firstOrNull ?? "{}");
  runApp(StudentApp(argMap["initialRoute"] ?? StudentApp.defaultRoute, argMap));
}

@pragma('vm:entry-point')
void alarm(List<String> args) async {
  int id;
  Map dataD = await Storage().initializeIntent();
  try {
    id = int.parse(args.first);
  } catch (_) {
    id = -1;
  }
  // Map f = {
  //   "seedColor": Colors.red.value,
  //   "font": null,
  //   "themeMode": 0,
  //   "subjectName": "Giai tich",
  //   "courseID": "GIAITICH1.1.14_BT",
  //   "startTime": "10:10",
  //   "location": "A999",
  //   "id": -1,
  // };
  runApp(AlarmApp(dataD[id] as Map));
}
