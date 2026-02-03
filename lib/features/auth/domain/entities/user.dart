// lib/features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final int classNumber;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool hasCompletedOnboarding;
  final String currentDifficulty;
  final int streakDays;
  final DateTime? lastActiveDate;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.classNumber,
    required this.createdAt,
    this.lastLoginAt,
    required this.hasCompletedOnboarding,
    required this.currentDifficulty,
    required this.streakDays,
    this.lastActiveDate,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    int? classNumber,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? hasCompletedOnboarding,
    String? currentDifficulty,
    int? streakDays,
    DateTime? lastActiveDate,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      classNumber: classNumber ?? this.classNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      currentDifficulty: currentDifficulty ?? this.currentDifficulty,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        classNumber,
        createdAt,
        lastLoginAt,
        hasCompletedOnboarding,
        currentDifficulty,
        streakDays,
        lastActiveDate,
      ];
}
