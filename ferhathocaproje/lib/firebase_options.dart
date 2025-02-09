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
    apiKey: 'AIzaSyDUd09cbXj1E1h_wx0qdwl7N_zBOcoPzvc',
    appId: '1:866468639430:web:53af76d80efb7ca469ddc7',
    messagingSenderId: '866468639430',
    projectId: 'ferhathocaproje',
    authDomain: 'ferhathocaproje.firebaseapp.com',
    storageBucket: 'ferhathocaproje.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAit1EFxW7qbalOyft3nOJ0sklZRbcMZzY',
    appId: '1:866468639430:android:61a66ad7a19cc71769ddc7',
    messagingSenderId: '866468639430',
    projectId: 'ferhathocaproje',
    storageBucket: 'ferhathocaproje.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1kChOe21Q3ELTig6k6LUkkr4IAn4cENY',
    appId: '1:866468639430:ios:c3fd5b76be64b51569ddc7',
    messagingSenderId: '866468639430',
    projectId: 'ferhathocaproje',
    storageBucket: 'ferhathocaproje.firebasestorage.app',
    iosBundleId: 'com.example.ferhathocaproje',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA1kChOe21Q3ELTig6k6LUkkr4IAn4cENY',
    appId: '1:866468639430:ios:c3fd5b76be64b51569ddc7',
    messagingSenderId: '866468639430',
    projectId: 'ferhathocaproje',
    storageBucket: 'ferhathocaproje.firebasestorage.app',
    iosBundleId: 'com.example.ferhathocaproje',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUd09cbXj1E1h_wx0qdwl7N_zBOcoPzvc',
    appId: '1:866468639430:web:6e610a0b967b6f3869ddc7',
    messagingSenderId: '866468639430',
    projectId: 'ferhathocaproje',
    authDomain: 'ferhathocaproje.firebaseapp.com',
    storageBucket: 'ferhathocaproje.firebasestorage.app',
  );
}
