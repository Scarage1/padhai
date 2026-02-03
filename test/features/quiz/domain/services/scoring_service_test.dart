// test/features/quiz/domain/services/scoring_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:padhai/features/quiz/domain/services/scoring_service.dart';

void main() {
  late ScoringService scoringService;
  
  setUp(() {
    scoringService = ScoringService();
  });
  
  group('calculateScore', () {
    test('calculates correct base score', () {
      final answers = List.generate(8, (_) => _correctAnswer()) +
                      List.generate(2, (_) => _incorrectAnswer());
      
      final score = scoringService.calculateScore(
        answers: answers,
        totalTimeSeconds: 600, // 10 minutes (par time)
      );
      
      expect(score.correctCount, equals(8));
      expect(score.baseScore, equals(80));
      expect(score.percentage, equals(80.0));
    });
    
    test('calculates time bonus correctly', () {
      final answers = List.generate(10, (_) => _correctAnswer());
      
      final score = scoringService.calculateScore(
        answers: answers,
        totalTimeSeconds: 400, // 200 seconds saved
      );
      
      expect(score.baseScore, equals(100));
      expect(score.timeBonus, equals(20)); // Max time bonus
      expect(score.totalScore, equals(120));
    });
    
    test('no time bonus when over par time', () {
      final answers = List.generate(10, (_) => _correctAnswer());
      
      final score = scoringService.calculateScore(
        answers: answers,
        totalTimeSeconds: 700, // Over par time
      );
      
      expect(score.timeBonus, equals(0));
      expect(score.totalScore, equals(100));
    });
    
    test('counts skipped answers correctly', () {
      final answers = [
        _correctAnswer(),
        _incorrectAnswer(),
        _skippedAnswer(),
        _skippedAnswer(),
      ];
      
      final score = scoringService.calculateScore(
        answers: answers,
        totalTimeSeconds: 300,
      );
      
      expect(score.correctCount, equals(1));
      expect(score.incorrectCount, equals(1));
      expect(score.skippedCount, equals(2));
    });
    
    test('handles all incorrect answers', () {
      final answers = List.generate(10, (_) => _incorrectAnswer());
      
      final score = scoringService.calculateScore(
        answers: answers,
        totalTimeSeconds: 300,
      );
      
      expect(score.baseScore, equals(0));
      expect(score.percentage, equals(0.0));
    });
  });
}

UserAnswer _correctAnswer() => const UserAnswer(isCorrect: true, isSkipped: false);
UserAnswer _incorrectAnswer() => const UserAnswer(isCorrect: false, isSkipped: false);
UserAnswer _skippedAnswer() => const UserAnswer(isCorrect: false, isSkipped: true);
