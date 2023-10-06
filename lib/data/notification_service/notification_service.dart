import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _fcm.requestPermission(sound: true, badge: true, alert: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  Future<String?> getFCMToken() async {
    try {
      final token = await _fcm.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  void _handleMessage(RemoteMessage message) {
    logger.d('Received message: ${message.notification?.title}');
  }
}
