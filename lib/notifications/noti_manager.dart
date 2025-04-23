import 'dart:math';

import 'package:daily_nest/notifications/local_noti.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotiManager {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    await messaging.requestPermission();
    String? token = await messaging.getToken();
    FirebaseMessaging.onBackgroundMessage(_handleBackground);
    _handleForegroundNoti();
  }

  static void _handleForegroundNoti() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotiManager.showBasicNotification(message: message);
    });
  }

  static Future<void> _handleBackground(RemoteMessage message) async {
    await Firebase.initializeApp();
   
  }

  static Future<String?> getToken() async {
    return await messaging.getToken();
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      return true;
    } else {
      return false;
    }
  }
}
