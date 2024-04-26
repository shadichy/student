import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/misc/misc_functions.dart';

// makes preset database
final class SPBasics {
  SPBasics._instance();
  static final _spBasicsInstance = SPBasics._instance();
  factory SPBasics() {
    return _spBasicsInstance;
  }

  late final List<List<int>> _studyTimeStamps;
  late final List<String> _onlineClassTypes;

  List<List<int>> get classTimeStamps => _studyTimeStamps;
  List<String> get onlineClass => _onlineClassTypes;

  Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("presets");
    if (rawInfo is! String) {
      rawInfo = await Server.getStudyProgramBasics;
      await SharedPrefs.setString("presets", rawInfo);
    }

    Map<String, dynamic> parsedInfo = {};

    try {
      parsedInfo = jsonDecode(rawInfo);
    } catch (e) {
      throw Exception("Failed to parse studyPlan info JSON from cache! $e");
    }

    _studyTimeStamps =
        MiscFns.listType<List>(parsedInfo["studyTimeStamps"] as List)
            .map((l) => MiscFns.listType<int>(l))
            .toList();
    _onlineClassTypes =
        MiscFns.listType<String>(parsedInfo["onlineClassTypes"] as List);
  }
}
