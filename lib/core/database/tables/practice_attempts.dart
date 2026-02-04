import 'package:drift/drift.dart';

@DataClassName('PracticeAttempt')
class PracticeAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  /// Foreign key to users table
  TextColumn get userId => text()();
  
  /// Foreign key to chapters table
  TextColumn get chapterId => text()();
  
  /// JSON array of question IDs attempted in this session
  TextColumn get questionIds => text()();
  
  /// Number of hints used in this practice session
  IntColumn get hintsUsed => integer().withDefault(const Constant(0))();
  
  /// Timestamp when practice session was completed
  IntColumn get completedAt => integer()();
}
