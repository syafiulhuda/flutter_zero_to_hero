# Flutter Zero to Hero

Selamat datang di proyek **Flutter Zero to Hero**!  
Aplikasi ini adalah wadah untuk berbagai fitur dan konsep Flutter, termasuk **manajemen status BLoC**, **navigasi GoRouter**, dan **integrasi Firebase**.

---

## 🚀 Memulai

### ⚙️ Persyaratan Sistem

- Flutter SDK (Versi stabil terbaru disarankan)
- Dart SDK
- Editor pilihan Anda (VS Code, Android Studio)

---

### 📦 Instalasi Dependensi

1. **Klon repositori ini**:
   ```bash
   git clone [URL_REPOSITORY]
   cd flutter_zth
   ```

2. **Ambil semua dependensi**:
   ```bash
   flutter pub get
   ```

---

### ▶️ Menjalankan Aplikasi

Jalankan di emulator atau perangkat fisik:

```bash
flutter run
```

---

## 🔥 Integrasi Firebase

Proyek ini memiliki integrasi dasar dengan Firebase untuk autentikasi (login/signup).

---

### 🧪 Dummy Firebase Configuration (Default)

Secara default, proyek ini menggunakan file `lib/firebase_options_dummy.dart` yang berisi konfigurasi dummy.

✅ Sudah include dalam Git (tidak di-`.gitignore`)  
✅ Bisa langsung dikompilasi dan dijalankan tanpa setup Firebase

### 💡 Mode Login Mock

Jika tidak mengonfigurasi Firebase asli, aplikasi akan berjalan dalam mode login mock:

- **Email:** `admin@gmail.com`  
- **Password:** `admin123`  

❗ Fitur Google Sign-In tidak aktif dalam mode ini.

---

## ⚙️ Konfigurasi Firebase Asli (Opsional)

Untuk fitur autentikasi Firebase asli:

### 🔧 1. Buat Proyek Firebase
- Kunjungi [Firebase Console](https://console.firebase.google.com)
- Buat proyek baru atau gunakan yang sudah ada

### 📱 2. Tambahkan Aplikasi
Tambahkan aplikasi Android/iOS/Web:

#### Android:
- Tambahkan `package name` (contoh: `com.example.flutterZth`)
- Unduh `google-services.json`
- Tempatkan di: `android/app/`

#### iOS:
- Tambahkan `Bundle ID` (contoh: `com.example.flutterZth`)
- Unduh `GoogleService-Info.plist`
- Tempatkan di: `ios/Runner/`

#### Web:
- Salin konfigurasi (API key, project ID, dsb.)

---

### 💻 3. Konfigurasi Dengan FlutterFire CLI

#### a. Instal Firebase CLI
```bash
npm install -g firebase-tools
```

#### b. Login ke Firebase
```bash
firebase login
```

#### c. Jalankan FlutterFire CLI
```bash
flutterfire configure
```

- Pilih proyek Firebase dan platform yang ingin dikaitkan
- **Timpa** import 'package:flutter_zth/firebase_options_dummy.dart'; di main.dart dengan import 'package:flutter_zth/firebase_options.dart';

---

Setelah selesai, aplikasi Anda akan terhubung ke Firebase asli dan dapat menggunakan fitur login sebenarnya melalui Firebase Authentication.
