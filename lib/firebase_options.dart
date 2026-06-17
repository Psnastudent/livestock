import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Configured automatically using your project details
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDMWBPY2KjEVdoLKIndq-WQY4gZgNcKVEk',
    appId: '1:1096428806906:web:e0a9e221bbbd4021d495f4', // Aligned client ID
    messagingSenderId: '1096428806906',
    projectId: 'toxic-plant-detection-b8e46',
    authDomain: 'toxic-plant-detection-b8e46.firebaseapp.com',
    storageBucket: 'toxic-plant-detection-b8e46.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMWBPY2KjEVdoLKIndq-WQY4gZgNcKVEk',
    appId: '1:1096428806906:android:0a9e221bbbd4021d495f43',
    messagingSenderId: '1096428806906',
    projectId: 'toxic-plant-detection-b8e46',
    storageBucket: 'toxic-plant-detection-b8e46.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMWBPY2KjEVdoLKIndq-WQY4gZgNcKVEk',
    appId: '1:1096428806906:ios:0a9e221bbbd4021d495f43', // Aligned client ID
    messagingSenderId: '1096428806906',
    projectId: 'toxic-plant-detection-b8e46',
    storageBucket: 'toxic-plant-detection-b8e46.firebasestorage.app',
    iosBundleId: 'com.srivarshan.toxicplantdetection',
  );
}
