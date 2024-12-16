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
    apiKey: 'AIzaSyDqPmPNL74h-tTp-J2HRhaFv6A2AyB8EG4',
    appId: '1:149482148378:web:a7674dd026e14b8a35b7a3',
    messagingSenderId: '149482148378',
    projectId: 'coffe-reference',
    authDomain: 'coffe-reference.firebaseapp.com',
    storageBucket: 'coffe-reference.firebasestorage.app',
    measurementId: 'G-XGSDNXZF6C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBI-uVP-zVJh73xN31JxbVSqHX958iMv_E',
    appId: '1:149482148378:android:2516e9becf73ccaf35b7a3',
    messagingSenderId: '149482148378',
    projectId: 'coffe-reference',
    storageBucket: 'coffe-reference.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-nhxXUH5tF6zooIfvPlF35cIOwZxcKfc',
    appId: '1:149482148378:ios:db46b61f4ba81b0335b7a3',
    messagingSenderId: '149482148378',
    projectId: 'coffe-reference',
    storageBucket: 'coffe-reference.firebasestorage.app',
    iosBundleId: 'com.example.adminApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-nhxXUH5tF6zooIfvPlF35cIOwZxcKfc',
    appId: '1:149482148378:ios:db46b61f4ba81b0335b7a3',
    messagingSenderId: '149482148378',
    projectId: 'coffe-reference',
    storageBucket: 'coffe-reference.firebasestorage.app',
    iosBundleId: 'com.example.adminApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXLV0Ym2LWF4cDbA2JFN5CL97qYCACS_U',
    appId: '1:149482148378:web:dfef9512e710b25835b7a3',
    messagingSenderId: '149482148378',
    projectId: 'coffe-reference',
    authDomain: 'coffe-reference.firebaseapp.com',
    storageBucket: 'coffe-reference.firebasestorage.app',
    measurementId: 'G-5TWL7959RK',
  );
}
