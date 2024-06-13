
// import 'package:shared_preferences/shared_preferences.dart';

// @Deprecated('Moving to Hive instead')
// abstract final class SharedPrefs {
//   static late final SharedPreferences _prefs;
//   static Future<void> initialize() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   static T? getString<T>(String key, [T? defaultValue]) {
//     try {
//       return jsonDecode(_prefs.getString(key)!);
//     } catch (e) {
//       return defaultValue;
//     }
//   }

//   static Future<void> setString(String key, Object? value) async =>
//       value != null
//           ? await _prefs.setString(key, jsonEncode(value))
//           : _prefs.remove(key);

//   static Future<void> clear() async => await _prefs.clear();
// }
