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
    apiKey: 'AIzaSyDUdApdIt69ZDepo-kKyyGzF7eSqy4tZ14',
    appId: '1:1041655485643:web:04ba6b0256da49fb0bb74e',
    messagingSenderId: '1041655485643',
    projectId: 'eventscout-3035d',
    authDomain: 'eventscout-3035d.firebaseapp.com',
    storageBucket: 'eventscout-3035d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwltjKU_odN3oYHEssLPz3yWGF5e0UUPc',
    appId: '1:1041655485643:android:91c49f939c25f5a30bb74e',
    messagingSenderId: '1041655485643',
    projectId: 'eventscout-3035d',
    storageBucket: 'eventscout-3035d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBULuthRRDQWSMzHg17FiruBwlcJyulQco',
    appId: '1:1041655485643:ios:4d9491996211f2870bb74e',
    messagingSenderId: '1041655485643',
    projectId: 'eventscout-3035d',
    storageBucket: 'eventscout-3035d.appspot.com',
    iosBundleId: 'com.example.events',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBULuthRRDQWSMzHg17FiruBwlcJyulQco',
    appId: '1:1041655485643:ios:7a24a21b5cbc45c60bb74e',
    messagingSenderId: '1041655485643',
    projectId: 'eventscout-3035d',
    storageBucket: 'eventscout-3035d.appspot.com',
    iosBundleId: 'com.example.events.RunnerTests',
  );
}
