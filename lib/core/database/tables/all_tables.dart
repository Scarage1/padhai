// lib/core/database/tables/all_tables.dart
// DO NOT MODIFY - Locked by DOC-004

import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get classNumber => integer().withDefault(const Constant(8))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();
  TextColumn get currentDifficulty =>
      text().withDefault(const Constant('beginner'))();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get iconName => text()();
  TextColumn get colorHex => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get chapterNumber => integer()();
  IntColumn get estimatedMinutes => integer()();
  BoolColumn get isLocked => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Topics extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text().references(Chapters, #id)();
  TextColumn get title => text()();
  TextColumn get content => text()(); // Markdown content
  IntColumn get topicNumber => integer()();
  IntColumn get estimatedMinutes => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Questions extends Table {
  TextColumn get id => text()();
  TextColumn get topicId => text().references(Topics, #id)();
  TextColumn get chapterId => text().references(Chapters, #id)();
  TextColumn get questionText => text()();
  TextColumn get questionType => text()(); // 'mcq' or 'true_false'
  TextColumn get options => text()(); // JSON array
  TextColumn get correctAnswer => text()();
  TextColumn get explanation => text()();
  TextColumn get difficulty => text()(); // 'beginner', 'intermediate', 'advanced'
  IntColumn get points => integer().withDefault(const Constant(10))();
  TextColumn get imageUrl => text().nullable()();
  
  // v1.1.0 additions
  TextColumn get ncertReference => text().nullable()(); // e.g., "Ch2.3.1"
  TextColumn get hint => text().nullable()(); // Hint for practice mode

  @override
  Set<Column> get primaryKey => {id};
}

class QuizAttempts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get chapterId => text().references(Chapters, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get totalQuestions => integer()();
  IntColumn get correctAnswers => integer().withDefault(const Constant(0))();
  IntColumn get score => integer().withDefault(const Constant(0))();
  IntColumn get maxScore => integer()();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();
  TextColumn get difficulty => text()();
  TextColumn get status =>
      text().withDefault(const Constant('in_progress'))(); // in_progress/completed/abandoned

  @override
  Set<Column> get primaryKey => {id};
}

class UserAnswers extends Table {
  TextColumn get id => text()();
  TextColumn get attemptId => text().references(QuizAttempts, #id)();
  TextColumn get questionId => text().references(Questions, #id)();
  TextColumn get selectedAnswer => text()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get timeSpentSeconds => integer()();
  DateTimeColumn get answeredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TopicProgress extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get topicId => text().references(Topics, #id)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAccessedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, topicId}
      ];
}

class UserDifficulty extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get difficultyLevel =>
      text().withDefault(const Constant('beginner'))();
  IntColumn get totalQuizzes => integer().withDefault(const Constant(0))();
  IntColumn get averageScore => integer().withDefault(const Constant(0))();
  IntColumn get consecutiveHighScores =>
      integer().withDefault(const Constant(0))();
  IntColumn get consecutiveLowScores =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUpdatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, subjectId}
      ];
}

class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get topicId => text().references(Topics, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, topicId}
      ];
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType =>
      text()(); // 'progress', 'quiz_attempt', 'bookmark'
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // 'create', 'update', 'delete'
  TextColumn get payload => text()(); // JSON data
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ===== v1.1.0 New Tables =====

class StudyResources extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  /// Type of study resource: 'summary', 'formula', 'concept_map', 'exam_tip'
  TextColumn get resourceType => text()();
  
  /// Foreign key to chapters table
  TextColumn get chapterId => text().references(Chapters, #id)();
  
  /// Title of the resource
  TextColumn get title => text()();
  
  /// Content in Markdown format
  TextColumn get content => text()();
  
  /// Optional file URL for downloadable PDFs
  TextColumn get fileUrl => text().nullable()();
  
  /// Timestamp when resource was created
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

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
  
  /// Next scheduled review date (Unix timestamp)
  IntColumn get nextReviewDate => integer().nullable()();
  
  /// Number of times reviewed
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  
  /// Last review date (Unix timestamp)
  IntColumn get lastReviewedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

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
  
  @override
  Set<Column> get primaryKey => {id};
}
