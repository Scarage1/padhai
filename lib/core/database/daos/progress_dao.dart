// lib/core/database/daos/progress_dao.dart
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [TopicProgress, UserDifficulty])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.db);

  Future<int> upsertTopicProgress(TopicProgressCompanion progress) {
    return into(topicProgress).insert(
      progress,
      onConflict: DoUpdate((_) => progress),
    );
  }

  Future<TopicProgressData?> getTopicProgress(String userId, String topicId) {
    return (select(topicProgress)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.topicId.equals(topicId)))
        .getSingleOrNull();
  }

  Future<List<TopicProgressData>> getUserProgress(String userId) {
    return (select(topicProgress)..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  Stream<List<TopicProgressData>> watchUserProgress(String userId) {
    return (select(topicProgress)..where((tbl) => tbl.userId.equals(userId)))
        .watch();
  }

  Future<int> upsertUserDifficulty(UserDifficultyCompanion difficulty) {
    return into(userDifficulty).insert(
      difficulty,
      onConflict: DoUpdate((_) => difficulty),
    );
  }

  Future<UserDifficultyData?> getUserDifficulty(String userId, String subjectId) {
    return (select(userDifficulty)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.subjectId.equals(subjectId)))
        .getSingleOrNull();
  }

  Stream<UserDifficultyData?> watchUserDifficulty(
    String userId,
    String subjectId,
  ) {
    return (select(userDifficulty)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.subjectId.equals(subjectId)))
        .watchSingleOrNull();
  }
}
