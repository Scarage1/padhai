// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/constants/storage_keys.dart';

@lazySingleton
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  // User token
  Future<String?> getToken() async {
    return await _storage.read(key: StorageKeys.userToken);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.userToken, value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: StorageKeys.userToken);
  }

  // Current user ID
  Future<String?> getCurrentUserId() async {
    return await _storage.read(key: StorageKeys.currentUserId);
  }

  Future<void> saveCurrentUserId(String userId) async {
    await _storage.write(key: StorageKeys.currentUserId, value: userId);
  }

  Future<void> deleteCurrentUserId() async {
    await _storage.delete(key: StorageKeys.currentUserId);
  }

  // Onboarding status
  Future<bool> hasCompletedOnboarding() async {
    final value = await _storage.read(key: StorageKeys.hasCompletedOnboarding);
    return value == 'true';
  }

  Future<void> saveOnboardingCompleted(bool completed) async {
    await _storage.write(
      key: StorageKeys.hasCompletedOnboarding,
      value: completed.toString(),
    );
  }

  Future<void> setOnboardingCompleted() async {
    await saveOnboardingCompleted(true);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

@module
abstract class StorageModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
