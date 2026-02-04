// lib/features/flashcards/domain/usecases/get_due_flashcards_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class GetDueFlashcardsUseCase {
  final AppDatabase _database;

  GetDueFlashcardsUseCase(this._database);

  Future<Either<Failure, List<Flashcard>>> call(String topicId) async {
    try {
      final flashcards = await _database.flashcardsDao
          .getDueFlashcards(topicId);

      return Right(flashcards);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
