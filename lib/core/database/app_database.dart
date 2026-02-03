// lib/core/database/app_database.dart
// DO NOT MODIFY - Locked by DOC-004

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:padhai/core/database/content_seeder.dart';
import 'package:padhai/core/database/daos/bookmarks_dao.dart';
import 'package:padhai/core/database/daos/chapters_dao.dart';
import 'package:padhai/core/database/daos/practice_attempts_dao.dart';
import 'package:padhai/core/database/daos/progress_dao.dart';
import 'package:padhai/core/database/daos/questions_dao.dart';
import 'package:padhai/core/database/daos/quiz_dao.dart';
import 'package:padhai/core/database/daos/study_resources_dao.dart';
import 'package:padhai/core/database/daos/subjects_dao.dart';
import 'package:padhai/core/database/daos/topics_dao.dart';
import 'package:padhai/core/database/daos/users_dao.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Subjects,
    Chapters,
    Topics,
    Questions,
    QuizAttempts,
    UserAnswers,
    TopicProgress,
    UserDifficulty,
    Bookmarks,
    SyncQueue,
    // v1.1.0 additions
    StudyResources,
    Flashcards,
    PracticeAttempts,
  ],
  daos: [
    UsersDao,
    SubjectsDao,
    ChaptersDao,
    TopicsDao,
    QuestionsDao,
    QuizDao,
    ProgressDao,
    BookmarksDao,
    StudyResourcesDao,
    PracticeAttemptsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // For testing
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2; // v1.1.0: Added StudyResources, Flashcards, PracticeAttempts tables + Questions columns

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _createIndexes();
          await _seedInitialData();
          await _seedContent();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Migration from v1 to v2 (v1.1.0 release)
          if (from == 1 && to == 2) {
            // Add new columns to Questions table
            await m.addColumn(questions, questions.ncertReference);
            await m.addColumn(questions, questions.hint);
            
            // Create new tables
            await m.createTable(studyResources);
            await m.createTable(flashcards);
            await m.createTable(practiceAttempts);
            
            // Create indexes for new tables
            await customStatement('CREATE INDEX IF NOT EXISTS idx_study_resources_chapter_id ON study_resources(chapter_id)');
            await customStatement('CREATE INDEX IF NOT EXISTS idx_flashcards_topic_id ON flashcards(topic_id)');
            await customStatement('CREATE INDEX IF NOT EXISTS idx_practice_attempts_user_id ON practice_attempts(user_id)');
            await customStatement('CREATE INDEX IF NOT EXISTS idx_practice_attempts_topic_id ON practice_attempts(topic_id)');
          }
        },
        beforeOpen: (details) async {
          // Enable foreign keys
          await customStatement('PRAGMA foreign_keys = ON');
          // Enable WAL mode for better performance
          await customStatement('PRAGMA journal_mode = WAL');
          // Optimize for read performance
          await customStatement('PRAGMA synchronous = NORMAL');
          await customStatement('PRAGMA cache_size = 10000');
        },
      );

  /// Create database indexes for performance per DOC-003 Section 3.5
  Future<void> _createIndexes() async {
    // Users
    await customStatement('CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)');

    // Chapters
    await customStatement('CREATE INDEX IF NOT EXISTS idx_chapters_subject_id ON chapters(subject_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_chapters_number ON chapters(chapter_number)');

    // Topics
    await customStatement('CREATE INDEX IF NOT EXISTS idx_topics_chapter_id ON topics(chapter_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_topics_number ON topics(topic_number)');

    // Questions
    await customStatement('CREATE INDEX IF NOT EXISTS idx_questions_topic_id ON questions(topic_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_questions_chapter_id ON questions(chapter_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_questions_difficulty ON questions(difficulty)');

    // Quiz Attempts
    await customStatement('CREATE INDEX IF NOT EXISTS idx_quiz_attempts_user_id ON quiz_attempts(user_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_quiz_attempts_chapter_id ON quiz_attempts(chapter_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_quiz_attempts_status ON quiz_attempts(status)');

    // User Answers
    await customStatement('CREATE INDEX IF NOT EXISTS idx_user_answers_attempt_id ON user_answers(attempt_id)');

    // Topic Progress
    await customStatement('CREATE INDEX IF NOT EXISTS idx_topic_progress_user_id ON topic_progress(user_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_topic_progress_topic_id ON topic_progress(topic_id)');

    // User Difficulty
    await customStatement('CREATE INDEX IF NOT EXISTS idx_user_difficulty_user_id ON user_difficulty(user_id)');

    // Bookmarks
    await customStatement('CREATE INDEX IF NOT EXISTS idx_bookmarks_user_id ON bookmarks(user_id)');

    // Sync Queue
    await customStatement('CREATE INDEX IF NOT EXISTS idx_sync_queue_is_synced ON sync_queue(is_synced)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_sync_queue_entity_type ON sync_queue(entity_type)');
  }

  Future<void> _seedInitialData() async {
    // Seed subjects
    await into(subjects).insert(
      SubjectsCompanion.insert(
        id: 'SUB_001',
        name: 'Science',
        description: 'Explore the natural world through experiments and discoveries',
        iconName: 'science',
        colorHex: '#4CAF50',
        sortOrder: 1,
      ),
    );
    await into(subjects).insert(
      SubjectsCompanion.insert(
        id: 'SUB_002',
        name: 'Mathematics',
        description: 'Master numbers, logic, and problem-solving skills',
        iconName: 'maths',
        colorHex: '#2196F3',
        sortOrder: 2,
      ),
    );

    // Seed chapters - Science
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB001_001',
        subjectId: 'SUB_001',
        name: 'Crop Production and Management',
        description: 'Learn about agricultural practices and crop management',
        chapterNumber: 1,
        estimatedMinutes: 45,
        isLocked: const Value(false),
      ),
    );
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB001_002',
        subjectId: 'SUB_001',
        name: 'Microorganisms: Friend and Foe',
        description: 'Discover the world of microorganisms and their impact',
        chapterNumber: 2,
        estimatedMinutes: 50,
      ),
    );
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB001_003',
        subjectId: 'SUB_001',
        name: 'Synthetic Fibres and Plastics',
        description: 'Understand synthetic materials and their applications',
        chapterNumber: 3,
        estimatedMinutes: 40,
      ),
    );
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB001_004',
        subjectId: 'SUB_001',
        name: 'Materials: Metals and Non-Metals',
        description: 'Explore properties of metals and non-metals',
        chapterNumber: 4,
        estimatedMinutes: 55,
      ),
    );
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB001_005',
        subjectId: 'SUB_001',
        name: 'Coal and Petroleum',
        description: 'Learn about fossil fuels and their uses',
        chapterNumber: 5,
        estimatedMinutes: 45,
      ),
    );

    // Seed chapters - Maths
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB002_001',
        subjectId: 'SUB_002',
        name: 'Rational Numbers',
        description: 'Master operations with rational numbers',
        chapterNumber: 1,
        estimatedMinutes: 60,
        isLocked: const Value(false),
      ),
    );
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB002_002',
        subjectId: 'SUB_002',
        name: 'Linear Equations in One Variable',
        description: 'Solve linear equations and word problems',
        chapterNumber: 2,
        estimatedMinutes: 55,
      ),
    );
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB002_003',
        subjectId: 'SUB_002',
        name: 'Understanding Quadrilaterals',
        description: 'Study properties of quadrilaterals',
        chapterNumber: 3,
        estimatedMinutes: 50,
      ),
    );
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB002_004',
        subjectId: 'SUB_002',
        name: 'Practical Geometry',
        description: 'Learn geometric constructions',
        chapterNumber: 4,
        estimatedMinutes: 45,
      ),
    );
    await into(chapters).insert(
      ChaptersCompanion.insert(
        id: 'CHT_SUB002_005',
        subjectId: 'SUB_002',
        name: 'Data Handling',
        description: 'Understand data representation and analysis',
        chapterNumber: 5,
        estimatedMinutes: 50,
      ),
    );
  }

  /// Seed topics and questions per DOC-011 Content Specification
  Future<void> _seedContent() async {
    final seeder = ContentSeeder(this);
    await seeder.seedAll();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'padhai.db'));
    return NativeDatabase(file);
  });
}
