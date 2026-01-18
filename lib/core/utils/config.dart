// lib/core/utils/config.dart

class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const String stripeApiKey = String.fromEnvironment(
    'STRIPE_API_KEY',
    defaultValue: '',
  );

  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  static const String appFlavor = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'dev',
  );

  static const String flutterWaveBaseUrl = String.fromEnvironment('FLUTTERWAVE_BASE_URL',
  defaultValue: 'https://api.flutterwave.com/v3');
}
