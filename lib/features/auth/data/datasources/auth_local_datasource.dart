// lib/features/auth/data/datasources/auth_local_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/storage/secure_storage.dart';
import 'package:padhai/features/auth/data/models/user_model.dart';
import 'package:padhai/features/auth/domain/entities/user.dart';

@injectable
class AuthLocalDataSource {
  final AppDatabase _database;
  final SecureStorage _secureStorage;

  AuthLocalDataSource(this._database, this._secureStorage);

  Future<User?> getCurrentUser() async {
    final userId = await _secureStorage.getCurrentUserId();
    if (userId == null) return null;

    final userData = await _database.usersDao.getUserById(userId);
    if (userData == null) return null;

    return UserModelExtension.fromDatabase(userData);
  }

  Future<void> saveUser(User user) async {
    await _database.usersDao.insertUser(user.toCompanion());
    await _secureStorage.saveCurrentUserId(user.id);
  }

  Future<void> updateUser(User user) async {
    await _database.usersDao.updateUser(user.toCompanion());
  }

  Future<void> clearUser() async {
    await _secureStorage.deleteCurrentUserId();
    await _secureStorage.deleteToken();
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getToken();
    final userId = await _secureStorage.getCurrentUserId();
    return token != null && userId != null;
  }
}
