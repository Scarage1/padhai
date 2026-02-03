// lib/features/study_materials/domain/usecases/get_resources_by_type_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class GetResourcesByTypeUseCase {
  final AppDatabase _database;

  GetResourcesByTypeUseCase(this._database);

  Future<Either<Failure, List<StudyResource>>> call({
    required int chapterId,
    required String resourceType,
  }) async {
    try {
      final resources = await _database.studyResourcesDao
          .getResourcesByChapterAndType(chapterId, resourceType);
      return Right(resources);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
