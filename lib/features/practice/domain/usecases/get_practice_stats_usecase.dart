// lib/features/practice/domain/usecases/get_practice_stats_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/daos/practice_attempts_dao.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class GetPracticeStatsUseCase {
  final AppDatabase _database;

  GetPracticeStatsUseCase(this._database);

  Future<Either<Failure, PracticeStats>> call({
    required String userId,
    required String chapterId,
  }) async {
    try {
      final stats = await _database.practiceAttemptsDao.getPracticeStats(
        userId,
        chapterId,
      );

      return Right(stats);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
