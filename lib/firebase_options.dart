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
    apiKey: 'AIzaSyC66tiF-fXn_D_aYbs5y2_KKrE0pu8kwtg',
    appId: '1:265545633931:web:1cd2dbf7ec2c0a3478048e',
    messagingSenderId: '265545633931',
    projectId: 'todoapp-13e03',
    authDomain: 'todoapp-13e03.firebaseapp.com',
    storageBucket: 'todoapp-13e03.appspot.com',
    measurementId: 'G-LW3QSM9NW8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANuBNh0oU9E5rABEoINfawTGJUC1Z-sJM',
    appId: '1:265545633931:android:e163b8168b8bfec778048e',
    messagingSenderId: '265545633931',
    projectId: 'todoapp-13e03',
    storageBucket: 'todoapp-13e03.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2QWG6LPuMRMN82nHII83OlhxgkNyvLtI',
    appId: '1:265545633931:ios:d82eb4e013fb2e2f78048e',
    messagingSenderId: '265545633931',
    projectId: 'todoapp-13e03',
    storageBucket: 'todoapp-13e03.appspot.com',
    iosBundleId: 'com.example.toDo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2QWG6LPuMRMN82nHII83OlhxgkNyvLtI',
    appId: '1:265545633931:ios:d889e28b410520f178048e',
    messagingSenderId: '265545633931',
    projectId: 'todoapp-13e03',
    storageBucket: 'todoapp-13e03.appspot.com',
    iosBundleId: 'com.example.toDo.RunnerTests',
  );
}