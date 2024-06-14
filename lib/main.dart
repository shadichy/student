import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/ui/connect.dart';
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
  try {
    id = int.parse(args.first);
  } catch (_) {
    id = -1;
  }
  main([
    jsonEncode({
      "initialRoute": StudentApp.alarmRoute,
      "id": id,
    })
  ]);
}
