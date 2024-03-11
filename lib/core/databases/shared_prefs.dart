import 'package:shared_preferences/shared_preferences.dart';

final class SharedPrefs {
  static late final SharedPreferences _prefs;
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getString(String key) => _prefs.getString(key);

  static Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);
}
