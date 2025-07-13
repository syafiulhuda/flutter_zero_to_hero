// lib/firebase_options.dart
// Ini adalah file placeholder untuk konfigurasi Firebase.
// Jika Anda ingin menggunakan layanan Firebase yang sebenarnya:
// 1. Dapatkan file konfigurasi (google-services.json untuk Android, GoogleService-Info.plist untuk iOS) dari Firebase Console Anda.
// 2. Jalankan perintah `flutterfire configure` di terminal di root proyek Anda.
// Perintah ini akan menimpa file ini dengan pengaturan proyek Firebase Anda yang sebenarnya.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Menyediakan opsi minimal, tidak fungsional untuk setiap platform.
    // Ini memungkinkan aplikasi untuk dikompilasi dan berjalan tanpa layanan Firebase
    // langsung menyebabkan crash ketika firebase_options.dart tidak dihasilkan melalui flutterfire configure.
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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'YOUR_ANDROID_API_KEY_HERE', // Ganti dengan kunci dummy atau biarkan seperti ini
    appId:
        '1:123456789012:android:dummy_android_app_id', // Ganti dengan ID dummy
    messagingSenderId: '123456789012',
    projectId: 'dummy-project-id',
    storageBucket: 'dummy-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY_HERE', // Ganti dengan kunci dummy
    appId: '1:123456789012:ios:dummy_ios_app_id', // Ganti dengan ID dummy
    messagingSenderId: '123456789012',
    projectId: 'dummy-project-id',
    storageBucket: 'dummy-project-id.appspot.com',
    androidClientId: 'dummy_android_client_id_for_ios', // Ganti dengan ID dummy
    iosClientId: 'dummy_ios_client_id', // Ganti dengan ID dummy
    iosBundleId:
        'com.example.flutterZth', // Pastikan ini sesuai dengan bundle ID aplikasi Anda
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY_HERE', // Ganti dengan kunci dummy
    appId: '1:123456789012:web:dummy_web_app_id', // Ganti dengan ID dummy
    messagingSenderId: '123456789012',
    projectId: 'dummy-project-id',
    authDomain: 'dummy-project-id.firebaseapp.com',
    storageBucket: 'dummy-project-id.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY_HERE',
    appId: '1:123456789012:ios:dummy_macos_app_id',
    messagingSenderId: '123456789012',
    projectId: 'dummy-project-id',
    storageBucket: 'dummy-project-id.appspot.com',
    androidClientId: 'dummy_android_client_id_for_macos',
    iosClientId: 'dummy_ios_client_id_for_macos',
    iosBundleId: 'com.example.flutterZth',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY_HERE',
    appId: '1:123456789012:web:dummy_windows_app_id',
    messagingSenderId: '123456789012',
    projectId: 'dummy-project-id',
    authDomain: 'dummy-project-id.firebaseapp.com',
    storageBucket: 'dummy-project-id.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY_HERE',
    appId: '1:123456789012:web:dummy_linux_app_id',
    messagingSenderId: '123456789012',
    projectId: 'dummy-project-id',
    authDomain: 'dummy-project-id.firebaseapp.com',
    storageBucket: 'dummy-project-id.appspot.com',
  );
}
