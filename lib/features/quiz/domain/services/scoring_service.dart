// lib/features/quiz/domain/services/scoring_service.dart

/// Quiz scoring rules
/// 
/// Base score: 10 points per correct answer
/// No negative marking for wrong/skipped answers
/// Bonus: +2 points for each second under par time (max +20)
/// 
/// Total possible: 100 points (base) + 20 (time bonus) = 120 max

class ScoringService {
  static const int pointsPerCorrect = 10;
  static const int questionsPerQuiz = 10;
  static const int maxTimeBonus = 20;
  static const int parTimePerQuestion = 60; // seconds
  
  QuizScore calculateScore({
    required List<UserAnswer> answers,
    required int totalTimeSeconds,
  }) {
    // Count correct answers
    final correctCount = answers
        .where((a) => a.isCorrect)
        .length;
    
    // Base score
    final baseScore = correctCount * pointsPerCorrect;
    
    // Time bonus calculation
    final parTime = questionsPerQuiz * parTimePerQuestion;
    final timeSaved = parTime - totalTimeSeconds;
    final timeBonus = timeSaved > 0 
        ? (timeSaved ~/ 10).clamp(0, maxTimeBonus) 
        : 0;
    
    // Total score
    final totalScore = baseScore + timeBonus;
    
    // Percentage (based on base score only, for difficulty calculation)
    final percentage = (correctCount / questionsPerQuiz) * 100;
    
    return QuizScore(
      correctCount: correctCount,
      incorrectCount: answers.where((a) => !a.isCorrect && !a.isSkipped).length,
      skippedCount: answers.where((a) => a.isSkipped).length,
      baseScore: baseScore,
      timeBonus: timeBonus,
      totalScore: totalScore,
      percentage: percentage,
      timeTakenSeconds: totalTimeSeconds,
    );
  }
}

class QuizScore {
  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final int baseScore;
  final int timeBonus;
  final int totalScore;
  final double percentage;
  final int timeTakenSeconds;
  
  const QuizScore({
    required this.correctCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.baseScore,
    required this.timeBonus,
    required this.totalScore,
    required this.percentage,
    required this.timeTakenSeconds,
  });
}

class UserAnswer {
  final bool isCorrect;
  final bool isSkipped;
  
  const UserAnswer({
    required this.isCorrect,
    required this.isSkipped,
  });
}
