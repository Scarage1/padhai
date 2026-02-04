// lib/core/content/content_initialization_service.dart
import 'package:flutter/foundation.dart';
import 'package:padhai/core/content/content_loader.dart';
import 'package:padhai/core/database/app_database.dart';

/// Service to initialize and load content into the database
class ContentInitializationService {
  final AppDatabase _database;
  final ContentLoader _contentLoader;

  ContentInitializationService(this._database)
      : _contentLoader = ContentLoader(_database);

  /// Load all sample content for testing
  /// Returns true if successful, false otherwise
  Future<bool> loadSampleContent() async {
    try {
      debugPrint('🔄 Loading sample content...');

      // Load questions
      final questionsLoaded = await _contentLoader.loadQuestionsFromJson(
        'assets/content/questions_science_ch1.json',
      );
      debugPrint('✅ Loaded $questionsLoaded questions');

      // Load study resources
      final resourcesLoaded = await _contentLoader.loadStudyResourcesFromJson(
        'assets/content/resources_science_ch1.json',
      );
      debugPrint('✅ Loaded $resourcesLoaded study resources');

      // Load flashcards
      final flashcardsLoaded = await _contentLoader.loadFlashcardsFromJson(
        'assets/content/flashcards_science_ch1.json',
      );
      debugPrint('✅ Loaded $flashcardsLoaded flashcards');

      debugPrint('🎉 Sample content loaded successfully!');
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading sample content: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Check if content is already loaded
  Future<bool> isContentLoaded() async {
    try {
      final questions = await _database.questionsDao.getAllQuestions();
      return questions.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Clear all content from database (for testing)
  Future<void> clearAllContent() async {
    try {
      debugPrint('🗑️ Clearing all content...');
      
      // Delete all questions
      await _database.delete(_database.questions).go();
      
      // Delete all study resources
      await _database.delete(_database.studyResources).go();
      
      // Delete all flashcards
      await _database.delete(_database.flashcards).go();
      
      debugPrint('✅ All content cleared');
    } catch (e) {
      debugPrint('❌ Error clearing content: $e');
    }
  }

  /// Load content if not already loaded
  Future<bool> ensureContentLoaded() async {
    final isLoaded = await isContentLoaded();
    if (isLoaded) {
      debugPrint('ℹ️ Content already loaded, skipping...');
      return true;
    }
    return await loadSampleContent();
  }
}
