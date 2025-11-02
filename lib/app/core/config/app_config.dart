import 'dart:io';

/// App configuration constants
class AppConfig {
  AppConfig._();

  /// Backend API base URL (Gemini-powered nutrition API)
  /// Automatically selects the correct URL based on platform
  ///
  /// Manual override options:
  /// - Android Emulator: http://10.0.2.2:3000
  /// - iOS Simulator: http://localhost:3000
  /// - Physical Device: http://YOUR_COMPUTER_IP:3000 (e.g., http://192.168.1.5:3000)
  static String get apiBaseUrl {
    // Uncomment and set your computer's IP if using a physical device
    // const physicalDeviceIP = 'http://192.168.1.5:3000';
    // return physicalDeviceIP;

    if (Platform.isAndroid) {
      // Android Emulator uses special IP to reach host machine
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      // iOS Simulator can use localhost directly
      return 'http://localhost:3000';
    } else {
      // Fallback for other platforms
      return 'http://localhost:3000';
    }
  }

  /// API timeout duration
  static const Duration apiTimeout = Duration(seconds: 30);

  /// Maximum items in search history
  static const int maxSearchHistoryItems = 10;

  /// App name
  static const String appName = 'CalPal';

  /// App version
  static const String appVersion = '1.0.0';
}
