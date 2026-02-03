// lib/core/database/daos/study_resources_dao.dart
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'study_resources_dao.g.dart';

@DriftAccessor(tables: [StudyResources])
class StudyResourcesDao extends DatabaseAccessor<AppDatabase>
    with _$StudyResourcesDaoMixin {
  StudyResourcesDao(super.db);

  /// Get all study resources for a chapter
  Future<List<StudyResource>> getResourcesByChapter(int chapterId) {
    return (select(studyResources)
          ..where((tbl) => tbl.chapterId.equals(chapterId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Get study resources by type (summary, formula, concept_map, exam_tip)
  Future<List<StudyResource>> getResourcesByType(String resourceType) {
    return (select(studyResources)
          ..where((tbl) => tbl.resourceType.equals(resourceType))
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Get study resources by chapter and type
  Future<List<StudyResource>> getResourcesByChapterAndType(
    int chapterId,
    String resourceType,
  ) {
    return (select(studyResources)
          ..where((tbl) =>
              tbl.chapterId.equals(chapterId) &
              tbl.resourceType.equals(resourceType))
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Get a specific study resource by ID
  Future<StudyResource?> getResourceById(int id) {
    return (select(studyResources)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert a new study resource
  Future<int> insertResource(StudyResourcesCompanion resource) {
    return into(studyResources).insert(resource);
  }

  /// Update an existing study resource
  Future<bool> updateResource(StudyResource resource) {
    return update(studyResources).replace(resource);
  }

  /// Delete a study resource
  Future<int> deleteResource(int id) {
    return (delete(studyResources)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Get count of resources by type for a chapter
  Future<int> getResourceCountByType(int chapterId, String resourceType) async {
    final countExp = studyResources.id.count();
    final query = selectOnly(studyResources)
      ..addColumns([countExp])
      ..where(studyResources.chapterId.equals(chapterId) &
          studyResources.resourceType.equals(resourceType));

    final result = await query.getSingleOrNull();
    return result?.read(countExp) ?? 0;
  }

  /// Watch resources for a chapter (reactive stream)
  Stream<List<StudyResource>> watchResourcesByChapter(int chapterId) {
    return (select(studyResources)
          ..where((tbl) => tbl.chapterId.equals(chapterId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  /// Watch resources by type (reactive stream)
  Stream<List<StudyResource>> watchResourcesByType(String resourceType) {
    return (select(studyResources)
          ..where((tbl) => tbl.resourceType.equals(resourceType))
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .watch();
  }
}
