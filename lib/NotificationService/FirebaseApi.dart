import 'dart:convert';
import 'dart:io';

import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/TodaysDueList/TodaysDueList.dart';
import 'package:empire_ios/screen/TodaysDueList/TodaysDueListCubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  // Private instances
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  // Notification channel configuration
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel1',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  // Main initialization method
  Future<void> initNotification(BuildContext context) async {
    try {
      // Request permissions
      await _requestPermissions();

      // Get and store FCM token
      getFCMToken();

      // Initialize push notifications
      await _initPushNotification(context);

      // Initialize local notifications
      await _initLocalNotification(context);

      // print("Firebase notifications initialized successfully");
    } catch (e) {
      // print("Error initializing Firebase notifications: $e");
    }
    subscribeToTopic("empire");
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // print("Notification permission status: ${settings.authorizationStatus}");
  }

  // Get FCM token
  Future<String?> getFCMToken() async {
    try {
      if (Myf.isIos() == true) {
        return await _getIOSToken();
      } else if (Platform.isAndroid) {
        return await _getAndroidToken();
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
    return null;
  }

  Future<String?> _getIOSToken() async {
    try {
      // Wait for APNs token to be available (iOS requirement)
      String? apnsToken = await _firebaseMessaging.getAPNSToken();

      if (apnsToken != null) {
        print('APNs Token: $apnsToken');

        // Now get FCM token
        fcmToken = await _firebaseMessaging.getToken() ?? "";
        print('iOS FCM Token: $fcmToken');
        return fcmToken;
      } else {
        // Retry logic for iOS
        return "";
      }
    } catch (e) {
      print('Error getting iOS FCM token: $e');
      return null;
    }
  }

  Future<String?> _getAndroidToken() async {
    try {
      // Android doesn't need APNs token, directly get FCM token
      fcmToken = await _firebaseMessaging.getToken() ?? "";
      print('Android FCM Token: $fcmToken');
      return fcmToken;
    } catch (e) {
      print('Error getting Android FCM token: $e');
      return null;
    }
  }

  // Initialize push notification handlers
  Future<void> _initPushNotification(BuildContext context) async {
    // Set foreground notification presentation options
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle initial message when app is opened from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _generateNotification(initialMessage);
    }

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _generateNotification(message);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print("Received foreground message: ${message.messageId}");
      _generateNotification(message);
    });

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Initialize local notifications
  Future<void> _initLocalNotification(BuildContext context) async {
    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // Android settings
    // Combined initialization settings
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    // Initialize plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationResponse(context, response);
      },
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    // Create notification channel for Android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  // Generate and display notification
  void _generateNotification(RemoteMessage message) {
    final notification = message.notification;

    if (notification == null) {
      // print("No notification payload found");
      return;
    }

    try {
      _flutterLocalNotificationsPlugin.show(
        message.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: androidSettings.defaultIcon,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    } catch (e) {
      // print("Error showing notification: $e");
    }
  }

  // Handle notification tap response
  void _handleNotificationResponse(BuildContext context, NotificationResponse response) {
    if (response.payload == null) return;

    try {
      final data = jsonDecode(response.payload!);
      final message = RemoteMessage.fromMap(data);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => TodaysDueListCubit(context),
            child: const TodaysDueList(),
          ),
        ),
      );
    } catch (e) {
      // print("Error handling notification response: $e");
    }
  }

  // Get current FCM token
  Future<String?> getCurrentToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      // print("Error getting current token: $e");
      return null;
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      // print("Subscribed to topic: $topic");
    } catch (e) {
      // print("Error subscribing to topic $topic: $e");
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      // print("Unsubscribed from topic: $topic");
    } catch (e) {
      // print("Error unsubscribing from topic $topic: $e");
    }
  }

  void saveTokenToFirebase(LoginUserModel loginUserModel) async {
    fireBCollection
        .collection("supuser")
        .doc(loginUserModel.cLIENTNO)
        .update({
          "user.${loginUserModel.loginUser}.fcmToken": fcmToken,
        })
        .then((value) {})
        .catchError((error) {});
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling background message: ${message.messageId}");
  // print("Background message data: ${message.data}");

  // Perform background operations here
  // Note: No BuildContext available in background handler
}

// Background notification tap handler
@pragma('vm:entry-point')
void _notificationTapBackground(NotificationResponse details) {
  // print("Background notification clicked: ${details.payload}");

  // Handle background notification tap
  // Note: No BuildContext available in background handler
}
