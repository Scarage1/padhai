// lib/core/database/daos/topics_dao.dart
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'topics_dao.g.dart';

@DriftAccessor(tables: [Topics])
class TopicsDao extends DatabaseAccessor<AppDatabase> with _$TopicsDaoMixin {
  TopicsDao(super.db);

  Future<List<Topic>> getTopicsByChapter(String chapterId) {
    return (select(topics)
          ..where((tbl) => tbl.chapterId.equals(chapterId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.topicNumber)]))
        .get();
  }

  Future<Topic?> getTopicById(String id) {
    return (select(topics)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<List<Topic>> watchTopicsByChapter(String chapterId) {
    return (select(topics)
          ..where((tbl) => tbl.chapterId.equals(chapterId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.topicNumber)]))
        .watch();
  }
}
