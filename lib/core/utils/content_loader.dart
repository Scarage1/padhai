import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables/all_tables.dart';

/// JSON content loader for hot-updatable question banks and study resources
/// Enables content team to add questions without code changes
@singleton
class ContentLoader {
  final AppDatabase _database;

  ContentLoader(this._database);

  /// Load questions from JSON file into database
  /// 
  /// JSON format:
  /// ```json
  /// {
  ///   "chapter_id": 1,
  ///   "questions": [
  ///     {
  ///       "id": "sci_ch1_q1",
  ///       "topic_id": 1,
  ///       "question_text": "What is photosynthesis?",
  ///       "options": ["Option A", "Option B", "Option C", "Option D"],
  ///       "correct_answer": "Option A",
  ///       "explanation": "Detailed explanation here...",
  ///       "difficulty": "intermediate",
  ///       "ncert_reference": "Ch1.2.3",
  ///       "hint": "Think about how plants make food",
  ///       "image_url": "content/science/ch1/photosynthesis.png",
  ///       "question_type": "mcq"
  ///     }
  ///   ]
  /// }
  /// ```
  Future<int> loadQuestionsFromJson(String assetPath) async {
    try {
      // Load JSON from assets
      final jsonString = await rootBundle.loadString(assetPath);
      final data = json.decode(jsonString) as Map<String, dynamic>;

      final chapterId = (data['chapter_id'] ?? 0).toString();
      final questions = data['questions'] as List<dynamic>;

      int loadedCount = 0;

      for (final q in questions) {
        final questionData = q as Map<String, dynamic>;
        
        // Check if question already exists (by ID)
        final existingQuestion = await _database.questionsDao
            .getQuestionById(questionData['id'] as String);

        if (existingQuestion != null) {
          // Update existing question
          await _database.questionsDao.updateQuestion(
            existingQuestion.copyWith(
              topicId: (questionData['topic_id'] ?? 0).toString(),
              chapterId: chapterId,
              questionText: questionData['question_text'] as String,
              options: json.encode((questionData['options'] as List).cast<String>()),
              correctAnswer: questionData['correct_answer'] as String,
              explanation: questionData['explanation'] as String,
              difficulty: questionData['difficulty'] as String? ?? 'intermediate',
              imageUrl: questionData['image_url'] as String?,
              ncertReference: questionData['ncert_reference'] as String?,
              hint: questionData['hint'] as String?,
              questionType: questionData['question_type'] as String? ?? 'mcq',
            ),
          );
        } else {
          // Insert new question
          await _database.questionsDao.insertQuestion(
            QuestionsCompanion.insert(
              id: questionData['id'] as String,
              topicId: (questionData['topic_id'] ?? 0).toString(),
              chapterId: chapterId,
              questionText: questionData['question_text'] as String,
              options: json.encode((questionData['options'] as List).cast<String>()),
              correctAnswer: questionData['correct_answer'] as String,
              explanation: questionData['explanation'] as String,
              difficulty: questionData['difficulty'] as String? ?? 'intermediate',
              imageUrl: Value(questionData['image_url'] as String?),
              ncertReference: Value(questionData['ncert_reference'] as String?),
              hint: Value(questionData['hint'] as String?),
              questionType: questionData['question_type'] as String? ?? 'mcq',
            ),
          );
        }

        loadedCount++;
      }

      return loadedCount;
    } catch (e) {
      throw ContentLoadException(
        'Failed to load questions from $assetPath: $e',
      );
    }
  }

  /// Load study resources from JSON file into database
  /// 
  /// JSON format:
  /// ```json
  /// {
  ///   "resources": [
  ///     {
  ///       "type": "summary",
  ///       "chapter_id": 1,
  ///       "title": "Chapter 1 Summary",
  ///       "content": "# Key Points\n\n- Point 1\n- Point 2",
  ///       "file_url": "documents/summaries/science_ch1.pdf"
  ///     }
  ///   ]
  /// }
  /// ```
  Future<int> loadStudyResourcesFromJson(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final data = json.decode(jsonString) as Map<String, dynamic>;

      final resources = data['resources'] as List<dynamic>;
      int loadedCount = 0;

      for (final r in resources) {
        final resourceData = r as Map<String, dynamic>;

        await _database.into(_database.studyResources).insert(
          StudyResourcesCompanion.insert(
            resourceType: resourceData['type'] as String,
            chapterId: (resourceData['chapter_id'] ?? 0).toString(),
            title: resourceData['title'] as String,
            content: resourceData['content'] as String,
            fileUrl: Value(resourceData['file_url'] as String?),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
          mode: InsertMode.insertOrReplace,
        );

        loadedCount++;
      }

      return loadedCount;
    } catch (e) {
      throw ContentLoadException(
        'Failed to load resources from $assetPath: $e',
      );
    }
  }

  /// Load flashcards from JSON file into database
  /// 
  /// JSON format:
  /// ```json
  /// {
  ///   "flashcards": [
  ///     {
  ///       "topic_id": 1,
  ///       "term": "Photosynthesis",
  ///       "definition": "Process by which plants make food using sunlight"
  ///     }
  ///   ]
  /// }
  /// ```
  Future<int> loadFlashcardsFromJson(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final data = json.decode(jsonString) as Map<String, dynamic>;

      final flashcards = data['flashcards'] as List<dynamic>;
      int loadedCount = 0;

      for (final f in flashcards) {
        final flashcardData = f as Map<String, dynamic>;

        await _database.into(_database.flashcards).insert(
          FlashcardsCompanion.insert(
            topicId: (flashcardData['topic_id'] ?? 0).toString(),
            term: flashcardData['term'] as String,
            definition: flashcardData['definition'] as String,
            masteryLevel: Value(0), // Start at level 0
            nextReviewDate: Value(DateTime.now().millisecondsSinceEpoch), // Available immediately
            reviewCount: Value(0),
          ),
          mode: InsertMode.insertOrReplace,
        );

        loadedCount++;
      }

      return loadedCount;
    } catch (e) {
      throw ContentLoadException(
        'Failed to load flashcards from $assetPath: $e',
      );
    }
  }

  /// Batch load all content from assets directory
  /// Returns summary of loaded content
  Future<ContentLoadSummary> loadAllContent() async {
    int questionsLoaded = 0;
    int resourcesLoaded = 0;
    int flashcardsLoaded = 0;
    final errors = <String>[];

    // Load questions for each chapter
    for (int i = 1; i <= 5; i++) {
      try {
        questionsLoaded += await loadQuestionsFromJson(
          'assets/content/questions/science_ch$i.json',
        );
      } catch (e) {
        errors.add('Science Ch$i questions: $e');
      }

      try {
        questionsLoaded += await loadQuestionsFromJson(
          'assets/content/questions/mathematics_ch$i.json',
        );
      } catch (e) {
        errors.add('Mathematics Ch$i questions: $e');
      }
    }

    // Load study resources
    for (int i = 1; i <= 5; i++) {
      try {
        resourcesLoaded += await loadStudyResourcesFromJson(
          'assets/content/resources/science_ch$i.json',
        );
      } catch (e) {
        errors.add('Science Ch$i resources: $e');
      }

      try {
        resourcesLoaded += await loadStudyResourcesFromJson(
          'assets/content/resources/mathematics_ch$i.json',
        );
      } catch (e) {
        errors.add('Mathematics Ch$i resources: $e');
      }
    }

    // Load flashcards
    for (int i = 1; i <= 5; i++) {
      try {
        flashcardsLoaded += await loadFlashcardsFromJson(
          'assets/content/flashcards/science_ch$i.json',
        );
      } catch (e) {
        errors.add('Science Ch$i flashcards: $e');
      }

      try {
        flashcardsLoaded += await loadFlashcardsFromJson(
          'assets/content/flashcards/mathematics_ch$i.json',
        );
      } catch (e) {
        errors.add('Mathematics Ch$i flashcards: $e');
      }
    }

    return ContentLoadSummary(
      questionsLoaded: questionsLoaded,
      resourcesLoaded: resourcesLoaded,
      flashcardsLoaded: flashcardsLoaded,
      errors: errors,
    );
  }

  /// Get content version from metadata file
  Future<String> getContentVersion() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/content/metadata/version.json',
      );
      final data = json.decode(jsonString) as Map<String, dynamic>;
      return data['version'] as String;
    } catch (e) {
      return '1.0.0'; // Default version
    }
  }

  /// Check if content needs updating based on version
  Future<bool> needsContentUpdate(String currentVersion) async {
    final latestVersion = await getContentVersion();
    return latestVersion != currentVersion;
  }
}

class ContentLoadException implements Exception {
  final String message;
  ContentLoadException(this.message);

  @override
  String toString() => message;
}

class ContentLoadSummary {
  final int questionsLoaded;
  final int resourcesLoaded;
  final int flashcardsLoaded;
  final List<String> errors;

  ContentLoadSummary({
    required this.questionsLoaded,
    required this.resourcesLoaded,
    required this.flashcardsLoaded,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() {
    return '''
Content Load Summary:
  Questions: $questionsLoaded
  Resources: $resourcesLoaded
  Flashcards: $flashcardsLoaded
  Errors: ${errors.length}
${errors.isNotEmpty ? '\nErrors:\n${errors.map((e) => '  - $e').join('\n')}' : ''}
    ''';
  }
}
