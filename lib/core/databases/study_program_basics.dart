import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:currency_converter/Currency.dart';
import 'package:student/core/configs.dart';

// makes preset database
final class SPBasics {
  SPBasics._instance();
  static final _spBasicsInstance = SPBasics._instance();
  factory SPBasics() {
    return _spBasicsInstance;
  }

  late final List<List<int>> _studyTimeStamps;
  late final List<String> _onlineClassTypes;
  late final int _creditPrice;
  late final Currency _currency;

  List<List<int>> get classTimeStamps => _studyTimeStamps;
  List<String> get onlineClass => _onlineClassTypes;
  int get creditPrice => _creditPrice;
  Currency get currency => _currency;

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
    _creditPrice = parsedInfo["creditPrice"] as int;
    String cr = (parsedInfo["currency"] == null
            ? defaultConfig["currency"]
            : parsedInfo["currency"] as String)
        .toLowerCase();
    _currency = Currency.values.firstWhere((_) => _.name == cr);
  }
}
