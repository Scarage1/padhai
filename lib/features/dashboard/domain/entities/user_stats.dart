// lib/features/dashboard/domain/entities/user_stats.dart
import 'package:equatable/equatable.dart';

class UserStats extends Equatable {
  final int totalTopicsCompleted;
  final int totalQuizAttempts;
  final int streakDays;
  final double averageScore;

  const UserStats({
    required this.totalTopicsCompleted,
    required this.totalQuizAttempts,
    required this.streakDays,
    required this.averageScore,
  });

  @override
  List<Object?> get props => [
        totalTopicsCompleted,
        totalQuizAttempts,
        streakDays,
        averageScore,
      ];
}
