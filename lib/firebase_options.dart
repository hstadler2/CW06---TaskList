// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

   static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC2V-1cCSriotCE2tL4v0FuBWSm3zQnUsc',
    appId: '1:255152092253:web:9d8ba6d55fb573e336c9b4',
    messagingSenderId: '255152092253',
    projectId: 'cw06-5f028',
    authDomain: 'cw06-5f028.firebaseapp.com',
    storageBucket: 'cw06-5f028.firebasestorage.app',
    measurementId: 'G-SJ5D3GFX0Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2_8Sb96tDvhbW8l34IUqEMu4K5hAKoBc',
    appId: '1:255152092253:android:47f93c4ffc2f576136c9b4',
    messagingSenderId: '255152092253',
    projectId: 'cw06-5f028',
    storageBucket: 'cw06-5f028.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2V-1cCSriotCE2tL4v0FuBWSm3zQnUsc',
    appId: '1:255152092253:web:0f0518513804c3fb36c9b4',
    messagingSenderId: '255152092253',
    projectId: 'cw06-5f028',
    authDomain: 'cw06-5f028.firebaseapp.com',
    storageBucket: 'cw06-5f028.firebasestorage.app',
    measurementId: 'G-96LQC5JVS2',
  );
}


