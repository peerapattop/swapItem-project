import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessging.requestPermission();

    final fCMToken = await _firebaseMessging.getToken();

    print('Token: $fCMToken');
  }
}
