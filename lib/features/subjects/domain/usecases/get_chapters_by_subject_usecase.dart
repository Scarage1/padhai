// lib/features/subjects/domain/usecases/get_chapters_by_subject_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/features/subjects/domain/entities/chapter_with_progress.dart';

@injectable
class GetChaptersBySubjectUseCase {
  final AppDatabase _database;

  GetChaptersBySubjectUseCase(this._database);

  Future<Either<Failure, List<ChapterWithProgress>>> call(
    String subjectId,
    String userId,
  ) async {
    try {
      // Get all chapters for the subject
      final chapters = await _database.chaptersDao.getChaptersBySubject(subjectId);

      // Get all topics to calculate total and completed counts
      final chaptersWithProgress = <ChapterWithProgress>[];

      for (final chapter in chapters) {
        // Get total topics for this chapter
        final topics = await _database.topicsDao.getTopicsByChapter(chapter.id);
        final totalTopics = topics.length;

        // Get completed topics count
        int completedTopics = 0;
        for (final topic in topics) {
          final progress = await _database.progressDao.getTopicProgress(userId, topic.id);
          if (progress?.isCompleted == true) {
            completedTopics++;
          }
        }

        // Determine if chapter is unlocked
        // First chapter is always unlocked
        // Others unlock when previous chapter has 80% topics completed
        bool isUnlocked = false;
        if (chapter.chapterNumber == 1) {
          isUnlocked = true;
        } else {
          // Find previous chapter
          final previousChapter = chapters.firstWhere(
            (c) => c.chapterNumber == chapter.chapterNumber - 1,
            orElse: () => chapter, // If not found, unlock current
          );
          
          if (previousChapter.id != chapter.id) {
            final prevTopics = await _database.topicsDao.getTopicsByChapter(previousChapter.id);
            int prevCompleted = 0;
            for (final topic in prevTopics) {
              final progress = await _database.progressDao.getTopicProgress(userId, topic.id);
              if (progress?.isCompleted == true) {
                prevCompleted++;
              }
            }
            // Unlock if previous chapter is 80% complete
            if (prevTopics.isNotEmpty) {
              isUnlocked = (prevCompleted / prevTopics.length) >= 0.8;
            }
          } else {
            isUnlocked = true;
          }
        }

        chaptersWithProgress.add(ChapterWithProgress(
          chapter: chapter,
          totalTopics: totalTopics,
          completedTopics: completedTopics,
          isUnlocked: isUnlocked,
        ));
      }

      return Right(chaptersWithProgress);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
