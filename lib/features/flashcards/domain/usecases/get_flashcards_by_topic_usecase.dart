// lib/features/flashcards/domain/usecases/get_flashcards_by_topic_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class GetFlashcardsByTopicUseCase {
  final AppDatabase _database;

  GetFlashcardsByTopicUseCase(this._database);

  Future<Either<Failure, List<Flashcard>>> call(int topicId) async {
    try {
      final flashcards = await _database.flashcardsDao
          .getFlashcardsByTopic(topicId);

      if (flashcards.isEmpty) {
        return Left(DatabaseFailure('No flashcards available for this topic'));
      }

      return Right(flashcards);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
