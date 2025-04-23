import 'dart:async';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotiManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final StreamController<NotificationResponse> streamController =
      StreamController<NotificationResponse>();

  
  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'default_channel_id', 
    'Default Channel', 
    channelDescription: 'Default notification channel',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    sound: null, 
    enableVibration: true,
    showWhen: true,
    autoCancel: true,
    icon: '@mipmap/ic_launcher', 
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    colorized: true,
    color: const Color.fromARGB(255, 0, 122, 255),
  );

  static void onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

   
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

   
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    
    await _createNotificationChannel();
  }

  static Future<void> _createNotificationChannel() async {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'default_channel_id',
        'Default Channel',
        description: 'Default notification channel',
        importance: Importance.max,
        playSound: true,
        sound: null,
      ),
    );
  }

  static Future<void> showBasicNotification({
   required RemoteMessage message
  }) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: _androidNotificationDetails,
          iOS: DarwinNotificationDetails(
            presentSound: true,
            presentBadge: true,
            presentAlert: true,
          ),
        ),
        payload: 'notification_payload',
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}
