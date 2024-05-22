import 'package:currency_converter/currency.dart';

Map<String, dynamic> defaultConfig = {
  'notif.reminders': [
    {"duration": 0},
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
  'opts.Home': [
    "settings",
    "status",
    "learning_result",
    "finance",
    "help",
  ],
  'opts.School': [
    "notif",
    "program",
    "learning_result",
    "student",
    "help",
  ],
  'opts.Student': [
    "student",
    "finance",
    "status",
    "learning_result",
    "settings",
    "help",
  ],
};

Map<String, String> env = {
  'fetchDomain': 'raw.githubusercontent.com',
  'apiPrefix': 'shadichydev/student/async/test/sample_db',
};
