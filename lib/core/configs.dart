import 'dart:convert';

// import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
// import 'package:student/core/databases/user.dart';
// import 'package:student/misc/misc_functions.dart';

final class AppConfig {
  AppConfig._instance();
  static final _studyPlanInstance = AppConfig._instance();
  factory AppConfig() {
    return _studyPlanInstance;
  }

  Map<String, dynamic> data = {};

  Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("config");
    if (rawInfo is! String) {
      await SharedPrefs.setString("studyPlan", defaultConfig.toString());
      data = defaultConfig;
    } else {
      data = jsonDecode(rawInfo) ?? defaultConfig;
    }
  }

  Future<void> _write() async {
    await SharedPrefs.setString("config", jsonEncode(data));
  }

  void setConfig(String id, dynamic value) {
    data[id] =
        (value is num || value is bool || value is Iterable || value is String)
            ? value
            : value.toString();
    _write();
  }

  dynamic getConfig<T>(String id) {
    switch (T) {
      case const (bool):
        return bool.tryParse("${data[id]}");
      case const (int):
        return int.tryParse("${data[id]}");
      case const (double):
        return double.tryParse("${data[id]}");
      case const (List):
        return data[id] ?? [];
      default:
        return data[id] as T?;
    }
  }
}

Map<String, dynamic> defaultConfig = {
  'notif.reminders': [
    {"duration": 30},
    {"duration": 60},
  ],
  'notif.reminder': true,
  'notif.topEvents': true,
  'notif.miscEvents': true,
  'notif.impNotif': true,
  'notif.clubNotif': true,
  'notif.miscNotif': true,
  'notif.appNotif': true,
  'theme.themeMode': 1,
  'theme.accentColor': 4294198070, // color red
  'settings.language': 'vi',
  'misc.startWeekday': 1,
};
