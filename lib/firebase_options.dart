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
    apiKey: 'AIzaSyBlGn5QPnsWR_AOIMl-s-UXibCSA43OqxM',
    appId: '1:606110309819:web:c709562b3235c0c135389e',
    messagingSenderId: '606110309819',
    projectId: 'bloc-photo-lib-course',
    authDomain: 'bloc-photo-lib-course.firebaseapp.com',
    storageBucket: 'bloc-photo-lib-course.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjIB1tvxGId37WIXhzuUzABGNL9-8f34Q',
    appId: '1:606110309819:android:5219db07f612149635389e',
    messagingSenderId: '606110309819',
    projectId: 'bloc-photo-lib-course',
    storageBucket: 'bloc-photo-lib-course.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC85tpMiaONhOEhtDOS_cnhsfAxZJsZefY',
    appId: '1:606110309819:ios:3277fcd656aba9df35389e',
    messagingSenderId: '606110309819',
    projectId: 'bloc-photo-lib-course',
    storageBucket: 'bloc-photo-lib-course.appspot.com',
    iosClientId: '606110309819-1jsvo4k9ogglba59lo0ff3t2q38s5etr.apps.googleusercontent.com',
    iosBundleId: 'com.example.blocTutorial',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC85tpMiaONhOEhtDOS_cnhsfAxZJsZefY',
    appId: '1:606110309819:ios:3277fcd656aba9df35389e',
    messagingSenderId: '606110309819',
    projectId: 'bloc-photo-lib-course',
    storageBucket: 'bloc-photo-lib-course.appspot.com',
    iosClientId: '606110309819-1jsvo4k9ogglba59lo0ff3t2q38s5etr.apps.googleusercontent.com',
    iosBundleId: 'com.example.blocTutorial',
  );
}
