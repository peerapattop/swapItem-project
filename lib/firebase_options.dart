// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyASBBPQMyTa3XdWYMvTLuBBx_SHtjTILsA',
    appId: '1:308895664903:web:0c4d1c8dda81d390bd53a2',
    messagingSenderId: '308895664903',
    projectId: 'swapitem-c0234',
    authDomain: 'swapitem-c0234.firebaseapp.com',
    databaseURL: 'https://swapitem-c0234-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'swapitem-c0234.appspot.com',
    measurementId: 'G-67X4ZC8MY7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_lUgdUUyiUlcZ2uRJsZF_hkyQaQqJSUk',
    appId: '1:308895664903:android:d4d1af4f94e221d8bd53a2',
    messagingSenderId: '308895664903',
    projectId: 'swapitem-c0234',
    databaseURL: 'https://swapitem-c0234-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'swapitem-c0234.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjcS9piH_Jihw7ylfaVGEIH1HcXWTMId8',
    appId: '1:308895664903:ios:5f398451c6b24adfbd53a2',
    messagingSenderId: '308895664903',
    projectId: 'swapitem-c0234',
    databaseURL: 'https://swapitem-c0234-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'swapitem-c0234.appspot.com',
    iosBundleId: 'com.example.swapitem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjcS9piH_Jihw7ylfaVGEIH1HcXWTMId8',
    appId: '1:308895664903:ios:08f63117f7a75a26bd53a2',
    messagingSenderId: '308895664903',
    projectId: 'swapitem-c0234',
    databaseURL: 'https://swapitem-c0234-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'swapitem-c0234.appspot.com',
    iosBundleId: 'com.example.swapitem.RunnerTests',
  );
}
