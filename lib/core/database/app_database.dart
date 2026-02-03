// lib/core/database/app_database.dart
// DO NOT MODIFY - Locked by DOC-004

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:padhai/core/database/daos/bookmarks_dao.dart';
import 'package:padhai/core/database/daos/chapters_dao.dart';
import 'package:padhai/core/database/daos/progress_dao.dart';
import 'package:padhai/core/database/daos/questions_dao.dart';
import 'package:padhai/core/database/daos/quiz_dao.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // For testing
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedInitialData();
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'padhai.db'));
    return NativeDatabase(file);
  });
}
