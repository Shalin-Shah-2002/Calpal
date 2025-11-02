/// App configuration constants
class AppConfig {
  AppConfig._();

  /// Backend API base URL (Gemini-powered nutrition API)
  /// Now using Render hosted backend
  ///
  /// Production URL: https://calpal-app-backend.onrender.com
  /// Local development: Uncomment the platform-specific URLs below
  static String get apiBaseUrl {
    // Production backend on Render
    return 'https://calpal-app-backend.onrender.com';

    // Uncomment below for local development:
    // if (Platform.isAndroid) {
    //   return 'http://10.0.2.2:3000';
    // } else if (Platform.isIOS) {
    //   return 'http://localhost:3000';
    // } else {
    //   return 'http://localhost:3000';
    // }
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
