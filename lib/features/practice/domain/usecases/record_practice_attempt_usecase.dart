// lib/features/practice/domain/usecases/record_practice_attempt_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class RecordPracticeAttemptUseCase {
  final AppDatabase _database;

  RecordPracticeAttemptUseCase(this._database);

  Future<Either<Failure, int>> call({
    required String userId,
    required String chapterId,
    required List<String> questionIds,
    required int hintsUsed,
  }) async {
    try {
      final id = await _database.practiceAttemptsDao.recordPracticeAttempt(
        userId: userId,
        chapterId: chapterId,
        questionIds: questionIds,
        hintsUsed: hintsUsed,
      );

      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
