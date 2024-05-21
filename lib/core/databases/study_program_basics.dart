import 'package:student/core/databases/server.dart';
// import 'package:student/core/databases/user.dart';
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
  late final Map<int, int> _creditPrice;
  late final Currency _currency;

  final int currentYear =
      1 + DateTime.now().difference(MiscFns.epoch(589446000)).inDays ~/ 365.25;

  List<List<int>> get classTimestamps => _studyTimestamps;
  List<String> get onlineClass => _onlineClassTypes;
  Currency get currency => _currency;

  int? creditPrice(int schoolYear) => _creditPrice[schoolYear];

  Future<void> initialize() async {
    Map<String, dynamic> parsedInfo = await Server.getStudyProgramBasics;

    _studyTimestamps =
        MiscFns.list<List>(parsedInfo["studyTimestamps"] as List)
            .map((l) => MiscFns.list<int>(l))
            .toList();
    _onlineClassTypes =
        MiscFns.list<String>(parsedInfo["onlineClassTypes"] as List);
    _creditPrice = (parsedInfo["creditPrices"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(int.parse(key), value as int));
    String cr =
        ((parsedInfo["currency"] ?? defaultConfig["misc.currency"]) as String)
            .toLowerCase();
    _currency = Currency.values.firstWhere((c) => c.name == cr);
  }
}
