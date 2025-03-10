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
    apiKey: 'AIzaSyBEe4oXQgjbMLcnqKkZcjapGZK-zV4Lrhg',
    appId: '1:609183639614:web:cae4d183483d9c5561896f',
    messagingSenderId: '609183639614',
    projectId: 'parking-demo-28d80',
    authDomain: 'parking-demo-28d80.firebaseapp.com',
    storageBucket: 'parking-demo-28d80.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBEe4oXQgjbMLcnqKkZcjapGZK-zV4Lrhg',
    appId: '1:609183639614:web:907060ee18f14b1661896f',
    messagingSenderId: '609183639614',
    projectId: 'parking-demo-28d80',
    authDomain: 'parking-demo-28d80.firebaseapp.com',
    storageBucket: 'parking-demo-28d80.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNXNjTL2kqUFBw4dFwqTYDPQeVG5O_kf4',
    appId: '1:609183639614:android:b9413f78783a6cd761896f',
    messagingSenderId: '609183639614',
    projectId: 'parking-demo-28d80',
    storageBucket: 'parking-demo-28d80.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtvusfMlhHDV0pPc2aM7FBXyIVcpt3FZY',
    appId: '1:609183639614:ios:137bec12d17abeeb61896f',
    messagingSenderId: '609183639614',
    projectId: 'parking-demo-28d80',
    storageBucket: 'parking-demo-28d80.firebasestorage.app',
    iosBundleId: 'com.example.adminApp',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtvusfMlhHDV0pPc2aM7FBXyIVcpt3FZY',
    appId: '1:609183639614:ios:137bec12d17abeeb61896f',
    messagingSenderId: '609183639614',
    projectId: 'parking-demo-28d80',
    storageBucket: 'parking-demo-28d80.firebasestorage.app',
    iosBundleId: 'com.example.adminApp',
  );

}