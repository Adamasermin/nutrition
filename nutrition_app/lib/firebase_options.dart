// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyATvebU3IGPEtIMbRoirT6bsBwgfeKxeuA',
    appId: '1:67753090159:web:857659cea375110bd8c19a',
    messagingSenderId: '67753090159',
    projectId: 'gestion-nutrition',
    authDomain: 'gestion-nutrition.firebaseapp.com',
    storageBucket: 'gestion-nutrition.appspot.com',
    measurementId: 'G-9RNDZHBK6L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB19Xa-r_wBB05-vC_ztoZcbqkUOxqsraI',
    appId: '1:67753090159:android:c2c9c8e3f3b3458dd8c19a',
    messagingSenderId: '67753090159',
    projectId: 'gestion-nutrition',
    storageBucket: 'gestion-nutrition.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwymASkZej66nM308zJMQmNw0ohisveE0',
    appId: '1:67753090159:ios:914885e27cdeabcad8c19a',
    messagingSenderId: '67753090159',
    projectId: 'gestion-nutrition',
    storageBucket: 'gestion-nutrition.appspot.com',
    iosBundleId: 'com.example.nutritionApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwymASkZej66nM308zJMQmNw0ohisveE0',
    appId: '1:67753090159:ios:914885e27cdeabcad8c19a',
    messagingSenderId: '67753090159',
    projectId: 'gestion-nutrition',
    storageBucket: 'gestion-nutrition.appspot.com',
    iosBundleId: 'com.example.nutritionApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyATvebU3IGPEtIMbRoirT6bsBwgfeKxeuA',
    appId: '1:67753090159:web:f9f3b7cb512723e9d8c19a',
    messagingSenderId: '67753090159',
    projectId: 'gestion-nutrition',
    authDomain: 'gestion-nutrition.firebaseapp.com',
    storageBucket: 'gestion-nutrition.appspot.com',
    measurementId: 'G-HCEM0B98MT',
  );
}