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
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABm7p8ZDE98hq5DN7izduwqG83TnbMWSA',
    appId: '1:832922255000:android:0166d2f593c04ac94b5aed',
    messagingSenderId: '832922255000',
    projectId: 'trackify-c5344',
    storageBucket: 'trackify-c5344.firebasestorage.app',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBO7URtNGKt7lCdVuMKYkirLWFZtqC2vh8',
    appId: '1:832922255000:web:a82753dd19eb0cd84b5aed',
    messagingSenderId: '832922255000',
    projectId: 'trackify-c5344',
    authDomain: 'trackify-c5344.firebaseapp.com',
    storageBucket: 'trackify-c5344.firebasestorage.app',
    measurementId: 'G-QTP68BYEFC',
  );
}
