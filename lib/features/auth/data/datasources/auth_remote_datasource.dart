// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:padhai/core/network/api_client.dart';
import 'package:padhai/core/storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

@injectable
class AuthRemoteDataSource {
  // ignore: unused_field - Will be used when backend is implemented
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  AuthRemoteDataSource(this._apiClient, this._secureStorage);

  // For v1.0.0, we're implementing offline-first without backend
  // These methods create mock responses matching expected API structure

  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // Mock successful login
    final userId = const Uuid().v4();
    final token = 'mock_token_$userId';

    await _secureStorage.saveToken(token);

    return {
      'user': {
        'id': userId,
        'email': email,
        'name': email.split('@').first,
        'class_number': 8,
        'created_at': DateTime.now().toIso8601String(),
        'has_completed_onboarding': false,
        'current_difficulty': 'beginner',
        'streak_days': 0,
      },
      'token': token,
    };
  }

  Future<Map<String, dynamic>> register(
    String email,
    String name,
    String password,
  ) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // Mock successful registration
    final userId = const Uuid().v4();
    final token = 'mock_token_$userId';

    await _secureStorage.saveToken(token);

    return {
      'user': {
        'id': userId,
        'email': email,
        'name': name,
        'class_number': 8,
        'created_at': DateTime.now().toIso8601String(),
        'has_completed_onboarding': false,
        'current_difficulty': 'beginner',
        'streak_days': 0,
      },
      'token': token,
    };
  }

  Future<void> logout() async {
    await _secureStorage.deleteToken();
  }
}
