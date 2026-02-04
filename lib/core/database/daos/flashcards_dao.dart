// lib/core/database/daos/flashcards_dao.dart
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'flashcards_dao.g.dart';

@DriftAccessor(tables: [Flashcards])
class FlashcardsDao extends DatabaseAccessor<AppDatabase>
    with _$FlashcardsDaoMixin {
  FlashcardsDao(super.db);

  /// Get all flashcards for a topic
  Future<List<Flashcard>> getFlashcardsByTopic(String topicId) {
    return (select(flashcards)
          ..where((tbl) => tbl.topicId.equals(topicId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)
          ]))
        .get();
  }

  /// Get flashcards due for review (next_review_date <= now)
  Future<List<Flashcard>> getDueFlashcards(String topicId) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (select(flashcards)
          ..where((tbl) =>
              tbl.topicId.equals(topicId) &
              tbl.nextReviewDate.isSmallerOrEqualValue(now))
          ..orderBy([
            (t) => OrderingTerm(expression: t.nextReviewDate, mode: OrderingMode.asc)
          ]))
        .get();
  }

  /// Get flashcards by mastery level
  Future<List<Flashcard>> getFlashcardsByMastery(String topicId, int masteryLevel) {
    return (select(flashcards)
          ..where((tbl) =>
              tbl.topicId.equals(topicId) &
              tbl.masteryLevel.equals(masteryLevel))
          ..orderBy([
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)
          ]))
        .get();
  }

  /// Update flashcard mastery (spaced repetition)
  /// Mastery levels: 0 (new) -> 1 (learning) -> 2 (familiar) -> 3 (known) -> 4 (mastered) -> 5 (perfect)
  Future<bool> updateMastery(int flashcardId, bool wasCorrect) async {
    final flashcard = await (select(flashcards)
          ..where((tbl) => tbl.id.equals(flashcardId)))
        .getSingleOrNull();

    if (flashcard == null) return false;

    int newMastery = flashcard.masteryLevel;
    int nextReview;

    if (wasCorrect) {
      // Increase mastery level (max 5)
      newMastery = (flashcard.masteryLevel + 1).clamp(0, 5);
      // Calculate next review date based on mastery level
      nextReview = _calculateNextReviewDate(newMastery);
    } else {
      // Decrease mastery level (min 0) or keep at 0
      newMastery = (flashcard.masteryLevel - 1).clamp(0, 5);
      // Review again soon if incorrect
      nextReview = DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch;
    }

    final updated = flashcard.copyWith(
      masteryLevel: newMastery,
      nextReviewDate: Value(nextReview),
      reviewCount: flashcard.reviewCount + 1,
    );

    return await update(flashcards).replace(updated);
  }

  /// Calculate next review date based on mastery level (Spaced Repetition)
  int _calculateNextReviewDate(int masteryLevel) {
    final now = DateTime.now();
    
    switch (masteryLevel) {
      case 0: // New
        return now.add(const Duration(minutes: 1)).millisecondsSinceEpoch;
      case 1: // Learning
        return now.add(const Duration(hours: 4)).millisecondsSinceEpoch;
      case 2: // Familiar
        return now.add(const Duration(days: 1)).millisecondsSinceEpoch;
      case 3: // Known
        return now.add(const Duration(days: 3)).millisecondsSinceEpoch;
      case 4: // Mastered
        return now.add(const Duration(days: 7)).millisecondsSinceEpoch;
      case 5: // Perfect
        return now.add(const Duration(days: 14)).millisecondsSinceEpoch;
      default:
        return now.add(const Duration(days: 1)).millisecondsSinceEpoch;
    }
  }

  /// Get flashcard statistics for a topic
  Future<FlashcardStats> getFlashcardStats(String topicId) async {
    final allCards = await getFlashcardsByTopic(topicId);
    
    if (allCards.isEmpty) {
      return FlashcardStats(
        total: 0,
        new_: 0,
        learning: 0,
        mastered: 0,
        dueForReview: 0,
      );
    }

    final now = DateTime.now();
    int newCount = 0;
    int learningCount = 0;
    int masteredCount = 0;
    int dueCount = 0;

    for (final card in allCards) {
      // Count by mastery level
      if (card.masteryLevel == 0) {
        newCount++;
      } else if (card.masteryLevel < 4) {
        learningCount++;
      } else {
        masteredCount++;
      }

      // Count due cards
      final now = DateTime.now().millisecondsSinceEpoch;
      if (card.nextReviewDate != null && card.nextReviewDate! <= now) {
        dueCount++;
      }
    }

    return FlashcardStats(
      total: allCards.length,
      new_: newCount,
      learning: learningCount,
      mastered: masteredCount,
      dueForReview: dueCount,
    );
  }

  /// Reset a flashcard to new state
  Future<bool> resetFlashcard(int flashcardId) async {
    final flashcard = await (select(flashcards)
          ..where((tbl) => tbl.id.equals(flashcardId)))
        .getSingleOrNull();

    if (flashcard == null) return false;

    final reset = flashcard.copyWith(
      masteryLevel: 0,
      nextReviewDate: Value(DateTime.now().millisecondsSinceEpoch),
      reviewCount: 0,
    );

    return await update(flashcards).replace(reset);
  }

  /// Insert a new flashcard
  Future<int> insertFlashcard(FlashcardsCompanion flashcard) {
    return into(flashcards).insert(flashcard);
  }

  /// Delete a flashcard
  Future<int> deleteFlashcard(int id) {
    return (delete(flashcards)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Watch flashcards for a topic (reactive stream)
  Stream<List<Flashcard>> watchFlashcardsByTopic(String topicId) {
    return (select(flashcards)
          ..where((tbl) => tbl.topicId.equals(topicId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)
          ]))
        .watch();
  }

  /// Watch due flashcards (reactive stream)
  Stream<List<Flashcard>> watchDueFlashcards(String topicId) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (select(flashcards)
          ..where((tbl) =>
              tbl.topicId.equals(topicId) &
              tbl.nextReviewDate.isSmallerOrEqualValue(now))
          ..orderBy([
            (t) => OrderingTerm(expression: t.nextReviewDate, mode: OrderingMode.asc)
          ]))
        .watch();
  }
}

/// Flashcard statistics model
class FlashcardStats {
  final int total;
  final int new_;
  final int learning;
  final int mastered;
  final int dueForReview;

  FlashcardStats({
    required this.total,
    required this.new_,
    required this.learning,
    required this.mastered,
    required this.dueForReview,
  });

  double get masteryPercentage => 
      total > 0 ? (mastered / total) * 100 : 0;

  String get masteryLabel {
    if (masteryPercentage >= 80) return 'Expert';
    if (masteryPercentage >= 60) return 'Proficient';
    if (masteryPercentage >= 40) return 'Competent';
    if (masteryPercentage >= 20) return 'Learning';
    return 'Beginner';
  }
}
