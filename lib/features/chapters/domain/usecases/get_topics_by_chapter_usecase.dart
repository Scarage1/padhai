// lib/features/chapters/domain/usecases/get_topics_by_chapter_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/features/chapters/domain/entities/topic_with_progress.dart';

@injectable
class GetTopicsByChapterUseCase {
  final AppDatabase _database;

  GetTopicsByChapterUseCase(this._database);

  Future<Either<Failure, List<TopicWithProgress>>> call(
    String chapterId,
    String userId,
  ) async {
    try {
      // Get all topics for the chapter
      final topics = await _database.topicsDao.getTopicsByChapter(chapterId);

      // Get progress for each topic
      final topicsWithProgress = <TopicWithProgress>[];

      for (final topic in topics) {
        final progress = await _database.progressDao.getTopicProgress(userId, topic.id);
        
        topicsWithProgress.add(TopicWithProgress(
          topic: topic,
          isCompleted: progress?.isCompleted ?? false,
          lastScore: null, // TopicProgress doesn't have score field
          lastAttemptAt: progress?.completedAt,
        ));
      }

      return Right(topicsWithProgress);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
