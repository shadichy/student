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
    String rawInfo = SharedPrefs.getString("config") ?? "{}";
    data = jsonDecode(rawInfo) ?? {};
  }

  Future<void> _write() async {
    await SharedPrefs.setString("config", jsonEncode(data));
  }

  void setConfig(String id, dynamic value) {
    data[id] = value.toString();
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
      default:
        return data[id] as T?;
    }
  }
}
