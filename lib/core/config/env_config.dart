/// Environment configuration per DOC-012 Section 12.2.2
/// Compile-time constants defined via --dart-define
abstract class EnvConfig {
  /// Current environment: development, staging, production
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// API base URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.padhai.com/v1',
  );

  /// Enable detailed logging
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  /// Enable Firebase Crashlytics
  static const bool enableCrashlytics = bool.fromEnvironment(
    'ENABLE_CRASHLYTICS',
    defaultValue: false,
  );

  /// Is production environment
  static bool get isProduction => environment == 'production';

  /// Is staging environment
  static bool get isStaging => environment == 'staging';

  /// Is development environment
  static bool get isDevelopment => environment == 'development';

  /// Should enable debug features
  static bool get enableDebugFeatures => !isProduction;
}
