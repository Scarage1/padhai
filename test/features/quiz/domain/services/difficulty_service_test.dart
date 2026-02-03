// test/features/quiz/domain/services/difficulty_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:padhai/features/quiz/domain/services/difficulty_service.dart';

void main() {
  late DifficultyService difficultyService;
  
  setUp(() {
    difficultyService = DifficultyService();
  });
  
  group('calculateDifficultyLevel', () {
    test('returns 1 (Beginner) when no attempts', () {
      final level = difficultyService.calculateDifficultyLevel(
        recentAttempts: [],
      );
      expect(level, equals(1));
    });
    
    test('returns 1 (Beginner) when average below 60%', () {
      final attempts = [
        _createAttempt(score: 40),
        _createAttempt(score: 50),
        _createAttempt(score: 45),
      ];
      
      final level = difficultyService.calculateDifficultyLevel(
        recentAttempts: attempts,
      );
      expect(level, equals(1));
    });
    
    test('returns 2 (Intermediate) when average 60-79%', () {
      final attempts = [
        _createAttempt(score: 65),
        _createAttempt(score: 70),
        _createAttempt(score: 75),
      ];
      
      final level = difficultyService.calculateDifficultyLevel(
        recentAttempts: attempts,
      );
      expect(level, equals(2));
    });
    
    test('returns 3 (Advanced) when average 80%+', () {
      final attempts = [
        _createAttempt(score: 85),
        _createAttempt(score: 90),
        _createAttempt(score: 88),
      ];
      
      final level = difficultyService.calculateDifficultyLevel(
        recentAttempts: attempts,
      );
      expect(level, equals(3));
    });
    
    test('applies weighted average correctly', () {
      // Most recent score has highest weight
      final attempts = [
        _createAttempt(score: 90, daysAgo: 0), // weight: 1.0
        _createAttempt(score: 30, daysAgo: 1), // weight: 0.8
        _createAttempt(score: 30, daysAgo: 2), // weight: 0.6
        _createAttempt(score: 30, daysAgo: 3), // weight: 0.4
        _createAttempt(score: 30, daysAgo: 4), // weight: 0.2
      ];
      // Weighted: (90*1 + 30*0.8 + 30*0.6 + 30*0.4 + 30*0.2) / 3.0
      // = (90 + 24 + 18 + 12 + 6) / 3.0 = 150 / 3.0 = 50
      
      final level = difficultyService.calculateDifficultyLevel(
        recentAttempts: attempts,
      );
      expect(level, equals(1)); // Below 60%
    });
    
    test('only considers last 5 attempts', () {
      final attempts = List.generate(10, (i) => 
        _createAttempt(score: 90, daysAgo: i),
      );
      
      // Only last 5 should be considered
      final level = difficultyService.calculateDifficultyLevel(
        recentAttempts: attempts,
      );
      expect(level, equals(3)); // 90% average
    });
  });
  
  group('shouldPromoteLevel', () {
    test('returns false when already at max level', () {
      final result = difficultyService.shouldPromoteLevel(
        currentLevel: 3,
        recentAttempts: [
          _createAttempt(score: 90, level: 3),
          _createAttempt(score: 90, level: 3),
          _createAttempt(score: 90, level: 3),
        ],
      );
      expect(result, isFalse);
    });
    
    test('returns true after 3 consecutive 80%+ at current level', () {
      final result = difficultyService.shouldPromoteLevel(
        currentLevel: 1,
        recentAttempts: [
          _createAttempt(score: 85, level: 1),
          _createAttempt(score: 82, level: 1),
          _createAttempt(score: 80, level: 1),
        ],
      );
      expect(result, isTrue);
    });
    
    test('returns false with only 2 qualifying attempts', () {
      final result = difficultyService.shouldPromoteLevel(
        currentLevel: 1,
        recentAttempts: [
          _createAttempt(score: 85, level: 1),
          _createAttempt(score: 82, level: 1),
        ],
      );
      expect(result, isFalse);
    });
    
    test('returns false when one attempt below 80%', () {
      final result = difficultyService.shouldPromoteLevel(
        currentLevel: 1,
        recentAttempts: [
          _createAttempt(score: 85, level: 1),
          _createAttempt(score: 75, level: 1), // Below 80%
          _createAttempt(score: 82, level: 1),
        ],
      );
      expect(result, isFalse);
    });
  });
  
  group('shouldDemoteLevel', () {
    test('returns false when already at min level', () {
      final result = difficultyService.shouldDemoteLevel(
        currentLevel: 1,
        recentAttempts: [
          _createAttempt(score: 30, level: 1),
          _createAttempt(score: 25, level: 1),
        ],
      );
      expect(result, isFalse);
    });
    
    test('returns true after 2 consecutive below 40%', () {
      final result = difficultyService.shouldDemoteLevel(
        currentLevel: 2,
        recentAttempts: [
          _createAttempt(score: 35, level: 2),
          _createAttempt(score: 30, level: 2),
        ],
      );
      expect(result, isTrue);
    });
    
    test('returns false with only 1 low attempt', () {
      final result = difficultyService.shouldDemoteLevel(
        currentLevel: 2,
        recentAttempts: [
          _createAttempt(score: 35, level: 2),
        ],
      );
      expect(result, isFalse);
    });
  });
}

QuizAttemptScore _createAttempt({
  required double score,
  int daysAgo = 0,
  int level = 1,
}) {
  return QuizAttemptScore(
    topicId: 'topic-1',
    difficultyLevel: level,
    scorePercentage: score,
    completedAt: DateTime.now().subtract(Duration(days: daysAgo)),
  );
}
