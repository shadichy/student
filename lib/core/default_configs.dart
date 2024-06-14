import 'package:currency_converter/currency.dart';
import 'package:student/core/routing.dart';

final class _Env {
  final fetchDomain = "fetchDomain";
  final apiPrefix = "apiPrefix";
  final headers = "headers";
}

final class _Settings {
  final language = "language";
}

final class _Notif {
  final reminders = "reminders";
  final reminder = "reminder";
  final reminderSound = "reminderSound";
  final topEvents = "topEvents";
  final miscEvents = "miscEvents";
  final impNotif = "impNotif";
  final clubNotif = "clubNotif";
  final miscNotif = "miscNotif";
  final appNotif = "appNotif";
}

final class _Theme {
  final systemTheme = "systemTheme";
  final themeMode = "themeMode";
  final accentColor = "accentColor";
  final appFont = "appFont";
}

final class _Misc {
  final startWeekday = "startWeekday";
  final currency = "currency";
}

final class _Opts {
  final Home = "Home";
  final School = "School";
  final Student = "Student";
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
    opts.Home: [
      Routing.routeNames.settings,
      Routing.routeNames.status,
      Routing.routeNames.learning_result,
      Routing.routeNames.finance,
      Routing.routeNames.help,
    ],
    opts.School: [
      Routing.routeNames.notif,
      Routing.routeNames.program,
      Routing.routeNames.learning_result,
      Routing.routeNames.student,
      Routing.routeNames.help,
    ],
    opts.Student: [
      Routing.routeNames.student,
      Routing.routeNames.finance,
      Routing.routeNames.status,
      Routing.routeNames.learning_result,
      Routing.routeNames.settings,
      Routing.routeNames.help,
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
