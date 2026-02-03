// lib/core/constants/app_constants.dart
// DO NOT MODIFY - Locked by DOC-002

abstract class AppConstants {
  // App Info
  static const String appName = 'Padhai';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  // User Class
  static const int targetClass = 8;

  // Quiz Configuration
  static const int questionsPerQuiz = 10;
  static const int passingPercentage = 60;
  static const int pointsPerQuestion = 10;

  // Difficulty Levels
  static const String difficultyBeginner = 'beginner';
  static const String difficultyIntermediate = 'intermediate';
  static const String difficultyAdvanced = 'advanced';

  // Question Types
  static const String questionTypeMCQ = 'mcq';
  static const String questionTypeTrueFalse = 'true_false';

  // Quiz Status
  static const String quizStatusInProgress = 'in_progress';
  static const String quizStatusCompleted = 'completed';
  static const String quizStatusAbandoned = 'abandoned';

  // Pagination
  static const int defaultPageSize = 20;

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(days: 7);

  // Streak
  static const int maxStreakDays = 365;
  
  // Subject IDs
  static const String subjectScience = 'SUB_001';
  static const String subjectMaths = 'SUB_002';
}
