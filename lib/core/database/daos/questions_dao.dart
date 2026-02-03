// lib/core/database/daos/questions_dao.dart
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'questions_dao.g.dart';

@DriftAccessor(tables: [Questions])
class QuestionsDao extends DatabaseAccessor<AppDatabase>
    with _$QuestionsDaoMixin {
  QuestionsDao(super.db);

  Future<List<Question>> getQuestionsByTopic(String topicId) {
    return (select(questions)..where((tbl) => tbl.topicId.equals(topicId)))
        .get();
  }

  Future<List<Question>> getQuestionsByChapter(String chapterId) {
    return (select(questions)..where((tbl) => tbl.chapterId.equals(chapterId)))
        .get();
  }

  Future<List<Question>> getQuestionsByDifficulty(
    String chapterId,
    String difficulty,
  ) {
    return (select(questions)
          ..where((tbl) =>
              tbl.chapterId.equals(chapterId) &
              tbl.difficulty.equals(difficulty)))
        .get();
  }

  Future<Question?> getQuestionById(String id) {
    return (select(questions)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }
}
