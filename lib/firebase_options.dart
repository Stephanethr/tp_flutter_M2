// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static final FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_W'] ?? '',
    appId: '1:558211690119:web:40d896d6a80b7aa2831222',
    messagingSenderId: '558211690119',
    projectId: 'tp-flutter-m2dfs',
    authDomain: 'tp-flutter-m2dfs.firebaseapp.com',
    storageBucket: 'tp-flutter-m2dfs.firebasestorage.app',
    measurementId: 'G-K2WKLBMN0M',
  );

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_A'] ?? '',
    appId: '1:558211690119:android:d95845ecda652709831222',
    messagingSenderId: '558211690119',
    projectId: 'tp-flutter-m2dfs',
    storageBucket: 'tp-flutter-m2dfs.firebasestorage.app',
  );

  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_I'] ?? '',
    appId: '1:558211690119:ios:1e0b5ca8d90b625f831222',
    messagingSenderId: '558211690119',
    projectId: 'tp-flutter-m2dfs',
    storageBucket: 'tp-flutter-m2dfs.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static final FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_I'] ?? '',
    appId: '1:558211690119:ios:1e0b5ca8d90b625f831222',
    messagingSenderId: '558211690119',
    projectId: 'tp-flutter-m2dfs',
    storageBucket: 'tp-flutter-m2dfs.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static final FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_W'] ?? '',
    appId: '1:558211690119:web:9f5fbb7466ed7499831222',
    messagingSenderId: '558211690119',
    projectId: 'tp-flutter-m2dfs',
    authDomain: 'tp-flutter-m2dfs.firebaseapp.com',
    storageBucket: 'tp-flutter-m2dfs.firebasestorage.app',
    measurementId: 'G-QQBXYTWGHF',
  );
}
