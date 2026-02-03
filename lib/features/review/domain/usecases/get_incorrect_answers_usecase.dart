import 'package:fpdart/fpdart.dart';
import '../../../../core/database/daos/quiz_dao.dart';
import '../../../../core/error/failures.dart';
import '../entities/incorrect_answer.dart';

// Use case to get incorrect answers for review
class GetIncorrectAnswersUseCase {
  final QuizDao _quizDao;

  GetIncorrectAnswersUseCase(this._quizDao);

  Future<Either<Failure, List<IncorrectAnswer>>> call({
    required String userId,
  }) async {
    try {
      // Get all user answers that were incorrect
      final attempts = await _quizDao.getUserQuizAttempts(userId);
      
      final List<IncorrectAnswer> incorrectAnswers = [];

      for (final attempt in attempts) {
        final userAnswers = await _quizDao.getUserAnswersByAttempt(attempt.id);
        
        // Filter incorrect answers
        final incorrect = userAnswers.where((answer) => !answer.isCorrect);
        
        for (final answer in incorrect) {
          // Note: Would need to join with Questions table to get full details
          incorrectAnswers.add(IncorrectAnswer(
            answerId: answer.id,
            questionText: 'Question ${answer.questionId}', // Would need join
            userAnswer: answer.selectedAnswer,
            correctAnswer: answer.correctAnswer,
            explanation: 'Explanation not available', // Would need join
            chapterName: 'Chapter', // Would need join
            subjectName: 'Subject', // Would need join
            attemptDate: attempt.completedAt ?? DateTime.now(),
          ));
        }
      }

      return right(incorrectAnswers);
    } catch (e) {
      return left(DatabaseFailure('Failed to fetch incorrect answers: ${e.toString()}'));
    }
  }
}
