import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'AIzaSyCx04JI8dA5cgJhQ5xGHAerJ66l33tr2dk',
  //   appId: '1:1016648032088:web:b7c539f097a75b5ef84f2d',
  //   messagingSenderId: '1016648032088',
  //   projectId: 'quickmed-development',
  //   authDomain: 'quickmed-development.firebaseapp.com',
  //   storageBucket: 'quickmed-development.appspot.com',
  //   measurementId: 'G-DP6M6MJX1F',
  // );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
    androidClientId: '',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
    iosClientId: '',
    iosBundleId: '',
  );
}
