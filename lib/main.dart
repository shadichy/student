import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:student/core/configs.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/ui/connect.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  Hive.init(null);
  await SharedPrefs.initialize();
  await AppConfig().initialize();
  if (AppConfig().getConfig<bool>("theme.systemTheme") == true) {
    await SystemTheme.accentColor.load();
  }
  // await NotificationService().initialize();
  runApp(const StudentApp());
}
