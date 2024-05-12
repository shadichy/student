import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:currency_converter/currency.dart';

// makes preset database
final class SPBasics {
  SPBasics._instance();
  static final _spBasicsInstance = SPBasics._instance();
  factory SPBasics() {
    return _spBasicsInstance;
  }

  late final List<List<int>> _studyTimestamps;
  late final List<String> _onlineClassTypes;
  late final Map<String, int> _creditPrice;
  late final Currency _currency;

  List<List<int>> get classTimestamps => _studyTimestamps;
  List<String> get onlineClass => _onlineClassTypes;
  Currency get currency => _currency;

  int? creditPrice(String schoolYear) => _creditPrice[schoolYear];

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

    _studyTimestamps =
        MiscFns.listType<List>(parsedInfo["studyTimestamps"] as List)
            .map((l) => MiscFns.listType<int>(l))
            .toList();
    _onlineClassTypes =
        MiscFns.listType<String>(parsedInfo["onlineClassTypes"] as List);
    _creditPrice = (parsedInfo["creditPrices"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as int));
    String cr =
        ((parsedInfo["currency"] ?? defaultConfig["misc.currency"]) as String)
            .toLowerCase();
    _currency = Currency.values.firstWhere((_) => _.name == cr);
  }
}
