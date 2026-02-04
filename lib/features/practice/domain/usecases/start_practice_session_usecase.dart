// lib/features/practice/domain/usecases/start_practice_session_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class StartPracticeSessionUseCase {
  final AppDatabase _database;

  StartPracticeSessionUseCase(this._database);

  /// Get random questions from a chapter for practice
  Future<Either<Failure, List<Question>>> call({
    required String chapterId,
    int count = 10,
    String? difficulty,
  }) async {
    try {
      List<Question> questions;
      
      if (difficulty != null) {
        questions = await _database.questionsDao
            .getQuestionsByChapterAndDifficulty(chapterId.toString(), difficulty);
      } else {
        questions = await _database.questionsDao
            .getQuestionsByChapter(chapterId.toString());
      }

      // Shuffle and take specified count
      questions.shuffle();
      final practiceQuestions = questions.take(count).toList();

      if (practiceQuestions.isEmpty) {
        return Left(DatabaseFailure('No questions available for practice'));
      }

      return Right(practiceQuestions);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
