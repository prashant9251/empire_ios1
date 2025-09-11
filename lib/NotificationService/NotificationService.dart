// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:flutter_timezone/flutter_timezone.dart';

// class NotificationService {
//   static final NotificationService _notificationService = NotificationService._internal();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   // Android initialization

//   NotificationService._internal();

//   Future<void> initNotification() async {
//     tz.initializeTimeZones(); // Initialize timezone data
//     final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
//     // Map deprecated/alias timezone names to canonical names
//     String fixedTimeZone = currentTimeZone == "Asia/Calcutta" ? "Asia/Kolkata" : currentTimeZone;
//     tz.setLocalLocation(tz.getLocation(fixedTimeZone)); // Set the local timezone
//     if (Myf.isAndroid()) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.requestNotificationsPermission();
//     } else if (Myf.isIos()) {
//       IOSFlutterLocalNotificationsPlugin? iosPlugin =
//           flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
//       await iosPlugin?.requestPermissions();
//     }
//     final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

//     // ios initialization
//     final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     // the initialization settings are initialized after they are setted
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     if (Myf.isAndroid()) {
//       await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//       if (Myf.isAndroid()) {
//         await flutterLocalNotificationsPlugin
//             .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//             ?.createNotificationChannel(channel);
//         tz.initializeTimeZones(); // Initialize timezone data
//         // showNotificationOnTime(0, "Test", "Test", time: DateTime.now().add(const Duration(seconds: 5)));
//       }
//     }
//   }

//   Future<void> showNotification({required int id, required String title, String body = ""}) async {
//     flutterLocalNotificationsPlugin.show(
//       title.hashCode,
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           color: Colors.blue,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//         ),
//       ),
//     );
//   }

//   bool isDateTimeInFuture(DateTime dateTime) {
//     return dateTime.isAfter(DateTime.now());
//   }

//   Future<void> showNotificationOnTime({int id = 1, required String title, required String body, required int? hour, required int? minute}) async {
//     if (hour == null || minute == null) {
//       throw ArgumentError("Hour and minute must be provided");
//     }
//     final location = tz.getLocation('Asia/Kolkata');
//     final now = tz.TZDateTime.now(location);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime(location, now.year, now.month, now.day, hour, minute),
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           color: Colors.blue,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exact,
//       matchDateTimeComponents: DateTimeComponents.time,
//       payload: body,
//     );
//     print("Notification scheduled for ${hour}:${minute.toString().padLeft(2, '0')} today.");
//   }

//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }
