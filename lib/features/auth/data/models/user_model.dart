// lib/features/auth/data/models/user_model.dart
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/features/auth/domain/entities/user.dart';

extension UserModelExtension on User {
  static User fromDatabase(UserData data) {
    return User(
      id: data.id,
      email: data.email,
      name: data.name,
      classNumber: data.classNumber,
      createdAt: data.createdAt,
      lastLoginAt: data.lastLoginAt,
      hasCompletedOnboarding: data.hasCompletedOnboarding,
      currentDifficulty: data.currentDifficulty,
      streakDays: data.streakDays,
      lastActiveDate: data.lastActiveDate,
    );
  }

  UsersCompanion toCompanion() {
    return UsersCompanion.insert(
      id: id,
      email: email,
      name: name,
      classNumber: classNumber,
      createdAt: createdAt,
      lastLoginAt: Value(lastLoginAt),
      hasCompletedOnboarding: Value(hasCompletedOnboarding),
      currentDifficulty: Value(currentDifficulty),
      streakDays: Value(streakDays),
      lastActiveDate: Value(lastActiveDate),
    );
  }
}
