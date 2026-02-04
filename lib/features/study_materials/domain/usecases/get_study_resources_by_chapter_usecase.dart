// lib/features/study_materials/domain/usecases/get_study_resources_by_chapter_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class GetStudyResourcesByChapterUseCase {
  final AppDatabase _database;

  GetStudyResourcesByChapterUseCase(this._database);

  Future<Either<Failure, List<StudyResource>>> call(String chapterId) async {
    try {
      final resources = await _database.studyResourcesDao
          .getResourcesByChapter(chapterId);
      return Right(resources);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
