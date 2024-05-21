import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._instance();
  static final _notificationService = NotificationService._instance();
  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      // ...
      // notificationCategories: [
      //   DarwinNotificationCategory(
      //     'demoCategory',
      //     actions: <DarwinNotificationAction>[
      //       DarwinNotificationAction.plain('id_1', 'Action 1'),
      //       DarwinNotificationAction.plain(
      //         'id_2',
      //         'Action 2',
      //         options: <DarwinNotificationActionOption>{
      //           DarwinNotificationActionOption.destructive,
      //         },
      //       ),
      //       DarwinNotificationAction.plain(
      //         'id_3',
      //         'Action 3',
      //         options: <DarwinNotificationActionOption>{
      //           DarwinNotificationActionOption.foreground,
      //         },
      //       ),
      //     ],
      //     options: <DarwinNotificationCategoryOption>{
      //       DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      //     },
      //   )
      // ],
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    //    showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title??''),
    //     content: Text(body??''),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }

  Future onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    // if (notificationResponse.payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<void> _showNotificationWithActions() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '...',
      '...',
      // '...',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Action 1'),
        AndroidNotificationAction('id_2', 'Action 2'),
        AndroidNotificationAction('id_3', 'Action 3'),
      ],
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, '...', '...', notificationDetails);
  }
}
