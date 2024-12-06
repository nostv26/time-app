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
    apiKey: 'AIzaSyBUCSjLP3wiAW9l7NTYRvi35VujG318Aho',
    appId: '1:874519737094:web:f08550bc81deeb0fe9a487',
    messagingSenderId: '874519737094',
    projectId: 'timer-5eafa',
    authDomain: 'timer-5eafa.firebaseapp.com',
    storageBucket: 'timer-5eafa.appspot.com',
    measurementId: 'G-ZSE7RNGCKK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1tP7riGFK1aX53dyRrfrD9AM0fADNpgw',
    appId: '1:874519737094:android:170c08351abe5933e9a487',
    messagingSenderId: '874519737094',
    projectId: 'timer-5eafa',
    storageBucket: 'timer-5eafa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoOzllYNhftosIfwoE7CzQEervFnDWg1Q',
    appId: '1:874519737094:ios:fc99cb9706016413e9a487',
    messagingSenderId: '874519737094',
    projectId: 'timer-5eafa',
    storageBucket: 'timer-5eafa.appspot.com',
    iosClientId:
        '874519737094-a23rm0j1e4duoh7pu4qvd2du7403oivb.apps.googleusercontent.com',
    iosBundleId: 'com.example.myAppTime',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoOzllYNhftosIfwoE7CzQEervFnDWg1Q',
    appId: '1:874519737094:ios:fc99cb9706016413e9a487',
    messagingSenderId: '874519737094',
    projectId: 'timer-5eafa',
    storageBucket: 'timer-5eafa.appspot.com',
    iosClientId:
        '874519737094-a23rm0j1e4duoh7pu4qvd2du7403oivb.apps.googleusercontent.com',
    iosBundleId: 'com.example.myAppTime',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBUCSjLP3wiAW9l7NTYRvi35VujG318Aho',
    appId: '1:874519737094:web:33eb47902f260287e9a487',
    messagingSenderId: '874519737094',
    projectId: 'timer-5eafa',
    authDomain: 'timer-5eafa.firebaseapp.com',
    storageBucket: 'timer-5eafa.appspot.com',
    measurementId: 'G-GPYBHHLJ6X',
  );
}
