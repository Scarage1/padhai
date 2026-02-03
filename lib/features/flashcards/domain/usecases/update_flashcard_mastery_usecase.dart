// lib/features/flashcards/domain/usecases/update_flashcard_mastery_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class UpdateFlashcardMasteryUseCase {
  final AppDatabase _database;

  UpdateFlashcardMasteryUseCase(this._database);

  Future<Either<Failure, bool>> call({
    required int flashcardId,
    required bool wasCorrect,
  }) async {
    try {
      final updated = await _database.flashcardsDao
          .updateMastery(flashcardId, wasCorrect);

      return Right(updated);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
