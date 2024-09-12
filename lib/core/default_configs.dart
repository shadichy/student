import 'package:currency_converter/currency.dart';
import 'package:student/core/routing.dart';

final class _Env {
  final fetchDomain = "fetchDomain";
  final apiPrefix = "apiPrefix";
  final headers = "headers";
}

final class _Settings {
  final language = "settings.language";
}

final class _Notif {
  final reminders = "notif.reminders";
  final reminder = "notif.reminder";
  final reminderSound = "notif.reminderSound";
  final topEvents = "notif.topEvents";
  final miscEvents = "notif.miscEvents";
  final impNotif = "notif.impNotif";
  final clubNotif = "notif.clubNotif";
  final miscNotif = "notif.miscNotif";
  final appNotif = "notif.appNotif";
}

final class _Theme {
  final systemTheme = "theme.systemTheme";
  final themeMode = "theme.themeMode";
  final accentColor = "theme.accentColor";
  final appFont = "theme.appFont";
}

final class _Misc {
  final startWeekday = "misc.startWeekday";
  final maxDlRetries = "misc.maxDlRetries";
  final dlRetryInterval = "misc.dlRetryInterval";
  final maxUEventItems = "misc.maxUEventItems";
  final currency = "misc.currency";
}

final class _Opts {
  // ignore: non_constant_identifier_names
  final Home = "opts.Home";
  // ignore: non_constant_identifier_names
  final School = "opts.School";
  // ignore: non_constant_identifier_names
  final Student = "opts.Student";
}

abstract final class Config {
  static final env = _Env();
  static final settings = _Settings();
  static final notif = _Notif();
  static final theme = _Theme();
  static final misc = _Misc();
  static final opts = _Opts();

  static final getDefaultConfig = {
    notif.reminders: [
      {"scheduleDuration": 0},
      {"scheduleDuration": 30},
      {"scheduleDuration": 60},
    ],
    notif.reminder: true,
    notif.topEvents: true,
    notif.miscEvents: true,
    notif.impNotif: true,
    notif.clubNotif: true,
    notif.miscNotif: true,
    notif.appNotif: true,
    theme.systemTheme: null,
    theme.themeMode: 1,
    theme.accentColor: 4294198070, // Colors.red.value,
    theme.appFont: null,
    settings.language: 'vi',
    misc.startWeekday: DateTime.monday,
    misc.currency: Currency.vnd.name,
    misc.maxDlRetries: 5,
    misc.dlRetryInterval: 120,
    misc.maxUEventItems: 3,
    opts.Home: [
      Routing.names.settings,
      Routing.names.status,
      Routing.names.learning_result,
      Routing.names.finance,
      Routing.names.help,
    ],
    opts.School: [
      Routing.names.notif,
      Routing.names.program,
      Routing.names.learning_result,
      Routing.names.student,
      Routing.names.help,
    ],
    opts.Student: [
      Routing.names.student,
      Routing.names.finance,
      Routing.names.status,
      Routing.names.learning_result,
      Routing.names.settings,
      Routing.names.help,
    ],
  };

  static final getEnv = {
    env.fetchDomain: 'raw.githubusercontent.com',
    env.apiPrefix: 'shadichydev/student/async/test/sample_db',
    env.headers: null
  };
}

Map<String, dynamic> defaultConfig = Config.getDefaultConfig;

Map<String, String?> env = Config.getEnv;
