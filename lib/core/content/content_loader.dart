import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:padhai/core/database/app_database.dart';

/// Content loader for JSON-based content files
/// Handles loading questions, study resources, and flashcards from JSON
class ContentLoader {
  final AppDatabase _database;

  ContentLoader(this._database);

  /// Load questions from a JSON file
  /// 
  /// Expected file path: assets/content/questions/science_ch1.json
  /// Returns number of questions loaded
  Future<int> loadQuestionsFromJson(String filePath) async {
    try {
      final jsonString = await rootBundle.loadString(filePath);
      final data = json.decode(jsonString) as Map<String, dynamic>;

      // Validate schema
      _validateQuestionSchema(data);

      int loaded = 0;
      final questions = data['questions'] as List<dynamic>;

      for (var q in questions) {
        await _database.questionsDao.insertQuestion(
          QuestionsCompanion.insert(
            id: q['id'] as String,
            topicId: q['topic_id'] as String,
            chapterId: (q['chapter_id'] ?? data['chapter_id']).toString(),
            questionText: q['question_text'] as String,
            questionType: (q['question_type'] ?? 'mcq') as String,
            options: json.encode(q['options']),
            correctAnswer: q['correct_answer'] as String,
            explanation: q['explanation'] as String,
            difficulty: (q['difficulty'] ?? 'beginner') as String,
            points: Value((q['points'] ?? 10) as int),
            imageUrl: Value(q['image_url'] as String?),
            ncertReference: Value(q['ncert_reference'] as String?),
            hint: Value(q['hint'] as String?),
          ),
        );
        loaded++;
      }

      return loaded;
    } catch (e) {
      throw ContentLoadException('Failed to load questions from $filePath: $e');
    }
  }

  /// Load study resources from JSON
  /// 
  /// Expected file path: assets/content/resources/study_materials.json
  /// Returns number of resources loaded
  Future<int> loadStudyResourcesFromJson(String filePath) async {
    try {
      final jsonString = await rootBundle.loadString(filePath);
      final data = json.decode(jsonString) as Map<String, dynamic>;

      int loaded = 0;
      final resources = data['resources'] as List<dynamic>;

      for (var r in resources) {
        await _database.into(_database.studyResources).insert(
          StudyResourcesCompanion.insert(
            resourceType: r['type'] as String,
            chapterId: (r['chapter_id'] as int).toString(),
            title: r['title'] as String,
            content: r['content'] as String,
            fileUrl: Value(r['file_url'] as String?),
            createdAt: r['created_at'] as int? ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
          ),
        );
        loaded++;
      }

      return loaded;
    } catch (e) {
      throw ContentLoadException('Failed to load study resources from $filePath: $e');
    }
  }

  /// Load flashcards from JSON
  /// 
  /// Expected file path: assets/content/resources/flashcards.json
  /// Returns number of flashcards loaded
  Future<int> loadFlashcardsFromJson(String filePath) async {
    try {
      final jsonString = await rootBundle.loadString(filePath);
      final data = json.decode(jsonString) as Map<String, dynamic>;

      int loaded = 0;
      final flashcards = data['flashcards'] as List<dynamic>;

      for (var f in flashcards) {
        await _database.into(_database.flashcards).insert(
          FlashcardsCompanion.insert(
            topicId: (f['topic_id'] as int).toString(),
            term: f['term'] as String,
            definition: f['definition'] as String,
            masteryLevel: Value(f['mastery_level'] as int? ?? 0),
            nextReviewDate: Value(f['next_review_date'] as int?),
            reviewCount: Value(f['review_count'] as int? ?? 0),
            lastReviewedAt: Value(f['last_reviewed_at'] as int?),
          ),
        );
        loaded++;
      }

      return loaded;
    } catch (e) {
      throw ContentLoadException('Failed to load flashcards from $filePath: $e');
    }
  }

  /// Validate question JSON schema
  void _validateQuestionSchema(Map<String, dynamic> data) {
    // Check required top-level fields
    if (!data.containsKey('chapter_id')) {
      throw ContentValidationException('Missing required field: chapter_id');
    }
    if (!data.containsKey('questions')) {
      throw ContentValidationException('Missing required field: questions');
    }
    if (data['questions'] is! List) {
      throw ContentValidationException('questions must be an array');
    }

    // Validate each question
    final questions = data['questions'] as List<dynamic>;
    for (var i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q is! Map<String, dynamic>) {
        throw ContentValidationException('Question $i is not an object');
      }

      // Check required question fields
      final requiredFields = [
        'id',
        'topic_id',
        'question_text',
        'options',
        'correct_answer',
        'explanation',
      ];

      for (var field in requiredFields) {
        if (!q.containsKey(field) || q[field] == null) {
          throw ContentValidationException(
            'Question $i missing required field: $field',
          );
        }
      }

      // Validate options is array
      if (q['options'] is! List) {
        throw ContentValidationException('Question $i: options must be an array');
      }

      // Validate correct answer is in options
      final options = q['options'] as List<dynamic>;
      if (!options.contains(q['correct_answer'])) {
        throw ContentValidationException(
          'Question $i: correct_answer "${q['correct_answer']}" not found in options',
        );
      }

      // Validate difficulty
      if (q.containsKey('difficulty')) {
        final validDifficulties = ['beginner', 'intermediate', 'advanced'];
        if (!validDifficulties.contains(q['difficulty'])) {
          throw ContentValidationException(
            'Question $i: invalid difficulty "${q['difficulty']}"',
          );
        }
      }

      // Validate question type
      if (q.containsKey('question_type')) {
        final validTypes = ['mcq', 'true_false'];
        if (!validTypes.contains(q['question_type'])) {
          throw ContentValidationException(
            'Question $i: invalid question_type "${q['question_type']}"',
          );
        }
      }
    }
  }

  /// Batch load all content files
  /// Returns map of file type to count loaded
  Future<Map<String, int>> loadAllContent() async {
    final results = <String, int>{};

    // Load questions from all chapter files
    final questionFiles = [
      'assets/content/questions/science_ch1.json',
      'assets/content/questions/science_ch2.json',
      'assets/content/questions/science_ch3.json',
      'assets/content/questions/science_ch4.json',
      'assets/content/questions/science_ch5.json',
      'assets/content/questions/math_ch1.json',
      'assets/content/questions/math_ch2.json',
      'assets/content/questions/math_ch3.json',
      'assets/content/questions/math_ch4.json',
      'assets/content/questions/math_ch5.json',
    ];

    int totalQuestions = 0;
    for (var file in questionFiles) {
      try {
        final count = await loadQuestionsFromJson(file);
        totalQuestions += count;
      } catch (e) {
        // File might not exist yet (content not created)
        // Skip silently during development
      }
    }
    results['questions'] = totalQuestions;

    // Load study resources
    try {
      results['study_resources'] = await loadStudyResourcesFromJson(
        'assets/content/resources/study_materials.json',
      );
    } catch (e) {
      results['study_resources'] = 0;
    }

    // Load flashcards
    try {
      results['flashcards'] = await loadFlashcardsFromJson(
        'assets/content/resources/flashcards.json',
      );
    } catch (e) {
      results['flashcards'] = 0;
    }

    return results;
  }
}

/// Exception thrown when content loading fails
class ContentLoadException implements Exception {
  final String message;
  ContentLoadException(this.message);

  @override
  String toString() => 'ContentLoadException: $message';
}

/// Exception thrown when content validation fails
class ContentValidationException implements Exception {
  final String message;
  ContentValidationException(this.message);

  @override
  String toString() => 'ContentValidationException: $message';
}
