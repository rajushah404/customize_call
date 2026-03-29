# 🛡️ ShieldCall - Advanced Android Call Screener

ShieldCall is a powerful, production-ready Android call screening application built with **Flutter** and **Kotlin**. It leverages the native Android `CallScreeningService` API to provide users with granular control over incoming calls, ensuring privacy and peace of mind.

![ShieldCall Header](https://raw.githubusercontent.com/rajushah404/customize_call/main/assets/readme_header.png) *Note: Header image placeholder*

## 🚀 Features

- **🎯 Smart Filtering**: Automatically filter calls based on multiple criteria.
- **🤫 Focus Mode**: Silence the noise. Only allow calls from your starred (favorite) contacts.
- **✅ Whitelist Mode**: Permit calls only from people already in your contact list.
- **🚫 Extreme Mode**: Block all incoming calls for total uninterrupted focus.
- **🛡️ Frequency Protection**: Prevent "spam bombing" by rejecting numbers that call too frequently within a short window.
- **📊 Real-time Logs**: Keep track of every blocked call with detailed timestamps and reasons.
- **🎨 Modern UI**: A sleek, dark-themed Material 3 interface built with Flutter.

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: BLoC (Business Logic Component)
- **Native Logic**: Kotlin (Android Call Screening Service)
- **Persistent Storage**: SharedPreferences (Shared between Flutter & Native)
- **Permissions Management**: Handled via `permission_handler`

## 🧩 How It Works

ShieldCall integrates deeply with the Android system through the **`CallScreeningService`**. When a call is received:
1. The Android System notifies ShieldCall's background service.
2. The service checks the user's active configuration (Focus Mode, Whitelist, etc.) stored in SharedPreferences.
3. Native Kotlin logic evaluates the rules against the incoming number.
4. The service responds to the system to either **Allow**, **Reject**, or **Silence** the call.
5. All actions are logged and synced back to the Flutter UI for review.

## 📦 Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/rajushah404/customize_call.git
   ```
2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```
4. **Permissions**: The app will request `PHONE` and `CONTACTS` permissions. You must also set ShieldCall as your **Default Call Screening App** in Android settings for full functionality.

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve ShieldCall.

---
Built with ❤️ by [Raju Shah](https://github.com/rajushah404)
