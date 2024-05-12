import 'package:currency_converter/currency.dart';

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
  'theme.accentColor': 4294198070, // Colors.red.value,
  'settings.language': 'vi',
  'misc.startWeekday': DateTime.monday,
  'misc.currency': Currency.vnd.name,
};

Map<String, String> env = {
  'fetchDomain': '192.168.240.1:8080',
  'apiPrefix': 'sample_db',
};
