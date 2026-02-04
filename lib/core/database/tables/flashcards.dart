import 'package:drift/drift.dart';

@DataClassName('Flashcard')
class Flashcards extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  /// Foreign key to topics table
  TextColumn get topicId => text()();
  
  /// Term or concept name
  TextColumn get term => text()();
  
  /// Definition or explanation
  TextColumn get definition => text()();
  
  /// Mastery level (0-5): 0 = new, 5 = mastered
  IntColumn get masteryLevel => integer().withDefault(const Constant(0))();
  
  /// Next scheduled review date (Unix timestamp in milliseconds)
  IntColumn get nextReviewDate => integer().nullable()();
  
  /// Number of times reviewed
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  
  /// Last review date (Unix timestamp in milliseconds)
  IntColumn get lastReviewedAt => integer().nullable()();
}
