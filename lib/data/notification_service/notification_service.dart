import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/push_notification/push_notification.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late ValueChanged<PushNotification>? onHandleMessage;

  PushNotificationService._privateConstructor();
  static final PushNotificationService _instance =
      PushNotificationService._privateConstructor();

  factory PushNotificationService() {
    return _instance;
  }

  Future<void> initialize(Function(String) onTokenRefresh) async {
    await _fcm.requestPermission(sound: true, badge: true, alert: true);
    final token = await _getFCMToken();
    if (token != null) {
      onTokenRefresh(token);
    }
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        _handleMessage(message);
      },
    );

    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => onTokenRefresh(token));
  }

  Future<String?> _getFCMToken() async {
    try {
      final token = await _fcm.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  void _handleMessage(RemoteMessage message) {
    logger.d('Received message: ${message.data.toJsonString()}');
    final pushNotification = PushNotification.fromJson(message.data);
    if (onHandleMessage != null) {
      onHandleMessage!(pushNotification);
    }
  }
}
