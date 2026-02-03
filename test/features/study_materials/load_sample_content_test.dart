// test/features/study_materials/load_sample_content_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/utils/content_loader.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;
  late ContentLoader contentLoader;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    contentLoader = ContentLoader(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Study Materials Content Loading', () {
    test('should load study resources from JSON', () async {
      // Load sample resources
      final count = await contentLoader.loadStudyResourcesFromJson(
        'assets/content/resources/science_ch1_sample.json',
      );

      expect(count, greaterThan(0));

      // Verify resources were loaded
      final resources = await database.studyResourcesDao
          .getResourcesByChapter(1);

      expect(resources.length, equals(count));
    });

    test('should load different resource types correctly', () async {
      await contentLoader.loadStudyResourcesFromJson(
        'assets/content/resources/science_ch1_sample.json',
      );

      // Check for each resource type
      final summaries = await database.studyResourcesDao
          .getResourcesByChapterAndType(1, 'summary');
      final formulas = await database.studyResourcesDao
          .getResourcesByChapterAndType(1, 'formula');
      final conceptMaps = await database.studyResourcesDao
          .getResourcesByChapterAndType(1, 'concept_map');
      final examTips = await database.studyResourcesDao
          .getResourcesByChapterAndType(1, 'exam_tip');

      expect(summaries.isNotEmpty, isTrue);
      expect(formulas.isNotEmpty, isTrue);
      expect(conceptMaps.isNotEmpty, isTrue);
      expect(examTips.isNotEmpty, isTrue);
    });

    test('should handle markdown content properly', () async {
      await contentLoader.loadStudyResourcesFromJson(
        'assets/content/resources/science_ch1_sample.json',
      );

      final summaries = await database.studyResourcesDao
          .getResourcesByChapterAndType(1, 'summary');

      final summary = summaries.first;
      expect(summary.content, contains('#')); // Markdown heading
      expect(summary.content, contains('Photosynthesis'));
    });
  });

  group('Content Version Management', () {
    test('should get content version', () async {
      final version = await contentLoader.getContentVersion();
      expect(version, isNotEmpty);
    });

    test('should check if update is needed', () async {
      final needsUpdate = await contentLoader.needsContentUpdate('1.0.0');
      expect(needsUpdate, isA<bool>());
    });
  });
}
