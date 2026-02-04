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

      int totalQuestions = 0;
      int totalResources = 0;
      int totalFlashcards = 0;

      // Load Chapter 1 content
      debugPrint('📖 Loading Chapter 1: Nutrition in Plants...');
      totalQuestions += await _contentLoader.loadQuestionsFromJson(
        'assets/content/questions_science_ch1.json',
      );
      totalResources += await _contentLoader.loadStudyResourcesFromJson(
        'assets/content/resources_science_ch1.json',
      );
      totalFlashcards += await _contentLoader.loadFlashcardsFromJson(
        'assets/content/flashcards_science_ch1.json',
      );

      // Load Chapter 2 content
      debugPrint('📖 Loading Chapter 2: Nutrition in Animals...');
      totalQuestions += await _contentLoader.loadQuestionsFromJson(
        'assets/content/questions_science_ch2.json',
      );
      totalResources += await _contentLoader.loadStudyResourcesFromJson(
        'assets/content/resources_science_ch2.json',
      );
      totalFlashcards += await _contentLoader.loadFlashcardsFromJson(
        'assets/content/flashcards_science_ch2.json',
      );

      debugPrint('✅ Loaded $totalQuestions questions');
      debugPrint('✅ Loaded $totalResources study resources');
      debugPrint('✅ Loaded $totalFlashcards flashcards');
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
