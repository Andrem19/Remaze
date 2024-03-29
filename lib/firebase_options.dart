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
    apiKey: 'AIzaSyDduVTlDUwkpuXvdIJN-vNaZ4oP-1cd7R8',
    appId: '1:830617567109:web:1f0ad2e846e0de6953ceec',
    messagingSenderId: '830617567109',
    projectId: 'mazegame-1cf72',
    authDomain: 'mazegame-1cf72.firebaseapp.com',
    storageBucket: 'mazegame-1cf72.appspot.com',
    measurementId: 'G-PWEW1FEKVE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDySpVIrRoFMaqgFQgZjjUdSRske9L8jEA',
    appId: '1:830617567109:android:910b756f85ac662e53ceec',
    messagingSenderId: '830617567109',
    projectId: 'mazegame-1cf72',
    storageBucket: 'mazegame-1cf72.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCAU1OpsUc4qXCn8cAHRi545WGwicT6KZ0',
    appId: '1:830617567109:ios:6b453b58efacf62e53ceec',
    messagingSenderId: '830617567109',
    projectId: 'mazegame-1cf72',
    storageBucket: 'mazegame-1cf72.appspot.com',
    iosClientId: '830617567109-s1tsou5anpdbh9rfr7th53q07osipi0f.apps.googleusercontent.com',
    iosBundleId: 'com.example.remaze',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCAU1OpsUc4qXCn8cAHRi545WGwicT6KZ0',
    appId: '1:830617567109:ios:6b453b58efacf62e53ceec',
    messagingSenderId: '830617567109',
    projectId: 'mazegame-1cf72',
    storageBucket: 'mazegame-1cf72.appspot.com',
    iosClientId: '830617567109-s1tsou5anpdbh9rfr7th53q07osipi0f.apps.googleusercontent.com',
    iosBundleId: 'com.example.remaze',
  );
}
