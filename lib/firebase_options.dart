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
    apiKey: 'AIzaSyASLi7ZP3RHqmfWxAwauL47y0Gwxq3DCQw',
    appId: '1:292373945139:web:032a7ca70a5fa110c73c46',
    messagingSenderId: '292373945139',
    projectId: 'nanjak-77aa5',
    authDomain: 'nanjak-77aa5.firebaseapp.com',
    storageBucket: 'nanjak-77aa5.appspot.com',
    measurementId: 'G-VPR219X45Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdeaUNaXJuaJPmhgVOfmwYDaMAuP-uetE',
    appId: '1:292373945139:android:9965ce504ff6ec04c73c46',
    messagingSenderId: '292373945139',
    projectId: 'nanjak-77aa5',
    storageBucket: 'nanjak-77aa5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbB_csGIZoxFYJGyQGj9qnt4cU4zBRtjY',
    appId: '1:292373945139:ios:7f8c0f09f8016031c73c46',
    messagingSenderId: '292373945139',
    projectId: 'nanjak-77aa5',
    storageBucket: 'nanjak-77aa5.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAbB_csGIZoxFYJGyQGj9qnt4cU4zBRtjY',
    appId: '1:292373945139:ios:7f8c0f09f8016031c73c46',
    messagingSenderId: '292373945139',
    projectId: 'nanjak-77aa5',
    storageBucket: 'nanjak-77aa5.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyASLi7ZP3RHqmfWxAwauL47y0Gwxq3DCQw',
    appId: '1:292373945139:web:0b8ec08e3aa2c908c73c46',
    messagingSenderId: '292373945139',
    projectId: 'nanjak-77aa5',
    authDomain: 'nanjak-77aa5.firebaseapp.com',
    storageBucket: 'nanjak-77aa5.appspot.com',
    measurementId: 'G-NRREWC5XEH',
  );
}
