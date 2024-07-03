import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sports_project/pages/notification_page/notification_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();



  initializeNotification() async {
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('icons8_sport');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        selectNotification(response.payload!);
      },
    );
  }



  requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      sound: true,
      alert: true,
      badge: true,
      provisional: true,
      critical: true,
    );
  }




  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Get.to(NotificationScreen(payload: payload));
  }




  displayNotification({required String title, required String body}) async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: 'Default_Sound');
  }





  schedualedNotfication() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }




  //older ios
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(Text(body!));
  }
}