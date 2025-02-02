// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

// Package imports:
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
    apiKey: 'AIzaSyDep-c3PKJCs7HZqS-_Y9GlkfWbKV0ZdXQ',
    appId: '1:608528534677:web:c52bc67632d43a14535f9c',
    messagingSenderId: '608528534677',
    projectId: 'stormymart-43ea8',
    authDomain: 'stormymart-43ea8.firebaseapp.com',
    storageBucket: 'stormymart-43ea8.appspot.com',
    measurementId: 'G-85JDHG6C7C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuBmhsave5zoZN_swU_07qP1OEL8U7nJk',
    appId: '1:608528534677:android:25e765a2f087e4eb535f9c',
    messagingSenderId: '608528534677',
    projectId: 'stormymart-43ea8',
    storageBucket: 'stormymart-43ea8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzR3ZLyb8Z8MdVou8glah1Zq4Ml_JTE_Y',
    appId: '1:608528534677:ios:3e6a628ad2034b96535f9c',
    messagingSenderId: '608528534677',
    projectId: 'stormymart-43ea8',
    storageBucket: 'stormymart-43ea8.appspot.com',
    androidClientId: '608528534677-1m2hee6gannajscag59hui1usrqonj96.apps.googleusercontent.com',
    iosClientId: '608528534677-m886tmbu704hsc72q1ucphv8fr3s4d1p.apps.googleusercontent.com',
    iosBundleId: 'com.rafiqul.stormymartV2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzR3ZLyb8Z8MdVou8glah1Zq4Ml_JTE_Y',
    appId: '1:608528534677:ios:ad200c263a5b6697535f9c',
    messagingSenderId: '608528534677',
    projectId: 'stormymart-43ea8',
    storageBucket: 'stormymart-43ea8.appspot.com',
    androidClientId: '608528534677-1m2hee6gannajscag59hui1usrqonj96.apps.googleusercontent.com',
    iosClientId: '608528534677-hrdl9ga74krm560tf371ue6oi9ah96cq.apps.googleusercontent.com',
    iosBundleId: 'com.rafiqul.stormymartV2.RunnerTests',
  );
}
