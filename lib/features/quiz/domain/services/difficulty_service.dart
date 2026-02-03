// lib/features/quiz/domain/services/difficulty_service.dart
import 'package:collection/collection.dart';

/// Calculate user's difficulty level for a specific topic
/// 
/// Formula: Uses weighted moving average of last 5 quiz attempts
/// Weight decreases for older attempts: [1.0, 0.8, 0.6, 0.4, 0.2]

class DifficultyService {
  static const List<double> weights = [1.0, 0.8, 0.6, 0.4, 0.2];
  static const int maxAttempts = 5;
  
  /// Calculate recommended difficulty level
  /// Returns: 1 (Beginner), 2 (Intermediate), 3 (Advanced)
  int calculateDifficultyLevel({
    required List<QuizAttemptScore> recentAttempts,
  }) {
    if (recentAttempts.isEmpty) {
      return 1; // Default to Beginner
    }
    
    // Sort by date descending (most recent first)
    final sortedAttempts = recentAttempts
        .sorted((a, b) => b.completedAt.compareTo(a.completedAt))
        .take(maxAttempts)
        .toList();
    
    // Calculate weighted average
    double weightedSum = 0;
    double totalWeight = 0;
    
    for (int i = 0; i < sortedAttempts.length; i++) {
      final weight = weights[i];
      final score = sortedAttempts[i].scorePercentage;
      weightedSum += score * weight;
      totalWeight += weight;
    }
    
    final weightedAverage = weightedSum / totalWeight;
    
    // Determine level based on thresholds
    if (weightedAverage >= 80) {
      return 3; // Advanced
    } else if (weightedAverage >= 60) {
      return 2; // Intermediate
    } else {
      return 1; // Beginner
    }
  }
  
  /// Check if user should be promoted to next level
  /// Requires: 3 consecutive quizzes at 80%+ on current level
  bool shouldPromoteLevel({
    required int currentLevel,
    required List<QuizAttemptScore> recentAttempts,
  }) {
    if (currentLevel >= 3) return false; // Already at max
    
    final sameLevelAttempts = recentAttempts
        .where((a) => a.difficultyLevel == currentLevel)
        .sorted((a, b) => b.completedAt.compareTo(a.completedAt))
        .take(3)
        .toList();
    
    if (sameLevelAttempts.length < 3) return false;
    
    return sameLevelAttempts.every((a) => a.scorePercentage >= 80);
  }
  
  /// Check if user should be demoted to previous level
  /// Requires: 2 consecutive quizzes at <40% on current level
  bool shouldDemoteLevel({
    required int currentLevel,
    required List<QuizAttemptScore> recentAttempts,
  }) {
    if (currentLevel <= 1) return false; // Already at min
    
    final sameLevelAttempts = recentAttempts
        .where((a) => a.difficultyLevel == currentLevel)
        .sorted((a, b) => b.completedAt.compareTo(a.completedAt))
        .take(2)
        .toList();
    
    if (sameLevelAttempts.length < 2) return false;
    
    return sameLevelAttempts.every((a) => a.scorePercentage < 40);
  }
}

class QuizAttemptScore {
  final String topicId;
  final int difficultyLevel;
  final double scorePercentage;
  final DateTime completedAt;
  
  const QuizAttemptScore({
    required this.topicId,
    required this.difficultyLevel,
    required this.scorePercentage,
    required this.completedAt,
  });
}
