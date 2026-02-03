// lib/features/dashboard/domain/usecases/get_subjects_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class GetSubjectsUseCase {
  final AppDatabase _database;

  GetSubjectsUseCase(this._database);

  Future<Either<Failure, List<Subject>>> call() async {
    try {
      final subjects = await _database.subjectsDao.getAllSubjects();
      return Right(subjects);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
