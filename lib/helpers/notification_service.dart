import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    await requestNotificationPermission();

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  static Future<void> requestNotificationPermission() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

 static notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'Sprayer App',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    await requestNotificationPermission();

    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  static Future showPeriodicNotification(
      {int id = 0, String? title, String? body, String? payLoad, RepeatInterval repeatInterval = RepeatInterval.weekly}) async {
    await requestNotificationPermission();

    return notificationsPlugin.periodicallyShow(
        id, title, body, repeatInterval, await notificationDetails());
  }

  static Future cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}
