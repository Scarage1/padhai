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
}
