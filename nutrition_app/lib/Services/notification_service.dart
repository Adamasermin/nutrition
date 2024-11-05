import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {

  final _firebaseMessage = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessage.requestPermission();
    final fCMToken = await _firebaseMessage.getToken();
    print('Token: ${fCMToken}');
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}

Future<void> handler(RemoteMessage message) async {
  print('Titre: ${message.notification?.title}');
  print('Message: ${message.notification?.body}');
  print('Payload: ${message.data}');

}