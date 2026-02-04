// lib/core/database/daos/practice_attempts_dao.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'practice_attempts_dao.g.dart';

@DriftAccessor(tables: [PracticeAttempts])
class PracticeAttemptsDao extends DatabaseAccessor<AppDatabase>
    with _$PracticeAttemptsDaoMixin {
  PracticeAttemptsDao(super.db);

  /// Record a new practice session
  Future<int> recordPracticeAttempt({
    required String userId,
    required String chapterId,
    required List<String> questionIds,
    required int hintsUsed,
  }) {
    return into(practiceAttempts).insert(
      PracticeAttemptsCompanion.insert(
        userId: userId,
        chapterId: chapterId,
        questionIds: json.encode(questionIds),
        completedAt: DateTime.now().millisecondsSinceEpoch,
        hintsUsed: hintsUsed,
      ),
    );
  }

  /// Get all practice attempts for a user
  Future<List<PracticeAttempt>> getPracticeAttemptsByUser(String userId) {
    return (select(practiceAttempts)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Get practice attempts for a specific chapter
  Future<List<PracticeAttempt>> getPracticeAttemptsByChapter(
    String userId,
    String chapterId,
  ) {
    return (select(practiceAttempts)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.chapterId.equals(chapterId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Get most recent practice attempt for a chapter
  Future<PracticeAttempt?> getLatestPracticeAttempt(
    String userId,
    int chapterId,
  ) {
    return (select(practiceAttempts)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.chapterId.equals(chapterId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get total practice sessions count for a user
  Future<int> getTotalPracticeCount(String userId) async {
    final countExp = practiceAttempts.id.count();
    final query = selectOnly(practiceAttempts)
      ..addColumns([countExp])
      ..where(practiceAttempts.userId.equals(userId));

    final result = await query.getSingleOrNull();
    return result?.read(countExp) ?? 0;
  }

  /// Get total hints used by a user
  Future<int> getTotalHintsUsed(String userId) async {
    final sumExp = practiceAttempts.hintsUsed.sum();
    final query = selectOnly(practiceAttempts)
      ..addColumns([sumExp])
      ..where(practiceAttempts.userId.equals(userId));

    final result = await query.getSingleOrNull();
    return result?.read(sumExp)?.toInt() ?? 0;
  }

  /// Get practice statistics for a chapter
  Future<PracticeStats> getPracticeStats(String userId, int chapterId) async {
    final attempts = await getPracticeAttemptsByChapter(userId, chapterId);
    
    if (attempts.isEmpty) {
      return PracticeStats(
        totalSessions: 0,
        totalQuestions: 0,
        totalHintsUsed: 0,
        lastPracticed: null,
      );
    }

    int totalQuestions = 0;
    int totalHints = 0;

    for (final attempt in attempts) {
      final questionIds = json.decode(attempt.questionIds) as List<dynamic>;
      totalQuestions += questionIds.length;
      totalHints += attempt.hintsUsed;
    }

    return PracticeStats(
      totalSessions: attempts.length,
      totalQuestions: totalQuestions,
      totalHintsUsed: totalHints,
      lastPracticed: attempts.isNotEmpty 
          ? DateTime.fromMillisecondsSinceEpoch(attempts.first.completedAt)
          : null,
    );
  }

  /// Delete a practice attempt
  Future<int> deletePracticeAttempt(int id) {
    return (delete(practiceAttempts)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Delete all practice attempts for a user
  Future<int> deleteAllPracticeAttempts(String userId) {
    return (delete(practiceAttempts)..where((tbl) => tbl.userId.equals(userId)))
        .go();
  }

  /// Watch practice attempts for a chapter (reactive stream)
  Stream<List<PracticeAttempt>> watchPracticeAttempts(
    String userId,
    String chapterId,
  ) {
    return (select(practiceAttempts)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.chapterId.equals(chapterId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)
          ]))
        .watch();
  }
}

/// Practice statistics model
class PracticeStats {
  final int totalSessions;
  final int totalQuestions;
  final int totalHintsUsed;
  final DateTime? lastPracticed;

  PracticeStats({
    required this.totalSessions,
    required this.totalQuestions,
    required this.totalHintsUsed,
    this.lastPracticed,
  });

  double get averageHintsPerSession =>
      totalSessions > 0 ? totalHintsUsed / totalSessions : 0;

  double get averageQuestionsPerSession =>
      totalSessions > 0 ? totalQuestions / totalSessions : 0;
}
