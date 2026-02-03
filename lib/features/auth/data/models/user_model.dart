// lib/features/auth/data/models/user_model.dart
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/features/auth/domain/entities/user.dart' as domain;
import 'package:drift/drift.dart';

extension UserModelExtension on domain.User {
  static domain.User fromDatabase(User data) {
    return domain.User(
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
      classNumber: Value(classNumber),
      createdAt: createdAt,
      lastLoginAt: Value(lastLoginAt),
      hasCompletedOnboarding: Value(hasCompletedOnboarding),
      currentDifficulty: Value(currentDifficulty),
      streakDays: Value(streakDays),
      lastActiveDate: Value(lastActiveDate),
    );
  }
}
