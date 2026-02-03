// lib/core/database/daos/chapters_dao.dart
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'chapters_dao.g.dart';

@DriftAccessor(tables: [Chapters])
class ChaptersDao extends DatabaseAccessor<AppDatabase>
    with _$ChaptersDaoMixin {
  ChaptersDao(super.db);

  Future<List<Chapter>> getChaptersBySubject(String subjectId) {
    return (select(chapters)
          ..where((tbl) => tbl.subjectId.equals(subjectId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.chapterNumber)]))
        .get();
  }

  Future<Chapter?> getChapterById(String id) {
    return (select(chapters)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<List<Chapter>> watchChaptersBySubject(String subjectId) {
    return (select(chapters)
          ..where((tbl) => tbl.subjectId.equals(subjectId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.chapterNumber)]))
        .watch();
  }
}
