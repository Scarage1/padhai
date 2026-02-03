// lib/features/flashcards/domain/usecases/get_flashcard_stats_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/daos/flashcards_dao.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class GetFlashcardStatsUseCase {
  final AppDatabase _database;

  GetFlashcardStatsUseCase(this._database);

  Future<Either<Failure, FlashcardStats>> call(int topicId) async {
    try {
      final stats = await _database.flashcardsDao
          .getFlashcardStats(topicId);

      return Right(stats);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
