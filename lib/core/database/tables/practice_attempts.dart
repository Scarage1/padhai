import 'package:drift/drift.dart';

@DataClassName('PracticeAttemptData')
class PracticeAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  /// Foreign key to users table
  IntColumn get userId => integer()();
  
  /// Foreign key to topics table
  IntColumn get topicId => integer()();
  
  /// Foreign key to questions table
  IntColumn get questionId => integer()();
  
  /// User's selected answer
  TextColumn get userAnswer => text()();
  
  /// Whether the answer was correct
  BoolColumn get isCorrect => boolean()();
  
  /// Whether hint was used for this question
  BoolColumn get hintUsed => boolean().withDefault(const Constant(false))();
  
  /// Timestamp when attempted
  IntColumn get attemptedAt => integer()();
  
  /// Time taken to answer (in seconds)
  IntColumn get timeTaken => integer().nullable()();
}
