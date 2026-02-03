// lib/core/constants/storage_keys.dart
// DO NOT MODIFY - Locked by DOC-002

abstract class StorageKeys {
  // User data
  static const String currentUserId = 'current_user_id';
  static const String userToken = 'user_token';
  static const String hasCompletedOnboarding = 'has_completed_onboarding';

  // App state
  static const String lastSyncTimestamp = 'last_sync_timestamp';
  static const String isDarkMode = 'is_dark_mode';
  static const String selectedLanguage = 'selected_language';

  // Cache
  static const String cachedSubjects = 'cached_subjects';
  static const String cachedChapters = 'cached_chapters';
}
