#!/usr/bin/env dart

/// Content validation script
/// Validates all JSON content files for schema correctness
/// 
/// Usage: dart scripts/validate_content.dart

import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔍 Starting content validation...\n');

  int totalFiles = 0;
  int validFiles = 0;
  int invalidFiles = 0;
  final errors = <String>[];

  // Validate question files
  final questionDir = Directory('assets/content/questions');
  if (await questionDir.exists()) {
    await for (var file in questionDir.list()) {
      if (file is File && file.path.endsWith('.json')) {
        totalFiles++;
        print('Validating: ${file.path}');
        
        try {
          await validateQuestionFile(file);
          validFiles++;
          print('  ✅ Valid\n');
        } catch (e) {
          invalidFiles++;
          errors.add('${file.path}: $e');
          print('  ❌ Invalid: $e\n');
        }
      }
    }
  }

  // Validate resource files
  final resourceDir = Directory('assets/content/resources');
  if (await resourceDir.exists()) {
    await for (var file in resourceDir.list()) {
      if (file is File && file.path.endsWith('.json')) {
        totalFiles++;
        print('Validating: ${file.path}');
        
        try {
          await validateResourceFile(file);
          validFiles++;
          print('  ✅ Valid\n');
        } catch (e) {
          invalidFiles++;
          errors.add('${file.path}: $e');
          print('  ❌ Invalid: $e\n');
        }
      }
    }
  }

  // Summary
  print('═══════════════════════════════════════');
  print('Validation Summary:');
  print('  Total files: $totalFiles');
  print('  Valid: $validFiles ✅');
  print('  Invalid: $invalidFiles ❌');
  print('═══════════════════════════════════════\n');

  if (errors.isNotEmpty) {
    print('Errors found:');
    for (var error in errors) {
      print('  • $error');
    }
    exit(1);
  } else {
    print('✨ All content files are valid!');
    exit(0);
  }
}

Future<void> validateQuestionFile(File file) async {
  final content = await file.readAsString();
  final data = json.decode(content) as Map<String, dynamic>;

  // Check required top-level fields
  _assertHasKey(data, 'chapter_id', 'Top level');
  _assertHasKey(data, 'questions', 'Top level');
  _assertIsArray(data, 'questions');

  final questions = data['questions'] as List<dynamic>;
  
  if (questions.isEmpty) {
    throw ValidationError('No questions found in file');
  }

  // Validate each question
  for (var i = 0; i < questions.length; i++) {
    final q = questions[i];
    
    if (q is! Map<String, dynamic>) {
      throw ValidationError('Question $i is not a JSON object');
    }

    // Required fields
    _assertHasKey(q, 'id', 'Question $i');
    _assertHasKey(q, 'topic_id', 'Question $i');
    _assertHasKey(q, 'question_text', 'Question $i');
    _assertHasKey(q, 'options', 'Question $i');
    _assertHasKey(q, 'correct_answer', 'Question $i');
    _assertHasKey(q, 'explanation', 'Question $i');

    // Validate options
    _assertIsArray(q, 'options');
    final options = q['options'] as List<dynamic>;
    
    if (options.length < 2) {
      throw ValidationError('Question $i: Must have at least 2 options');
    }

    // Validate correct answer is in options
    if (!options.contains(q['correct_answer'])) {
      throw ValidationError(
        'Question $i: correct_answer "${q['correct_answer']}" not in options',
      );
    }

    // Validate difficulty if present
    if (q.containsKey('difficulty')) {
      final validDifficulties = ['beginner', 'intermediate', 'advanced'];
      if (!validDifficulties.contains(q['difficulty'])) {
        throw ValidationError(
          'Question $i: Invalid difficulty "${q['difficulty']}"',
        );
      }
    }

    // Validate question type if present
    if (q.containsKey('question_type')) {
      final validTypes = ['mcq', 'true_false'];
      if (!validTypes.contains(q['question_type'])) {
        throw ValidationError(
          'Question $i: Invalid question_type "${q['question_type']}"',
        );
      }

      // True/False questions should have exactly 2 options
      if (q['question_type'] == 'true_false' && options.length != 2) {
        throw ValidationError(
          'Question $i: True/False questions must have exactly 2 options',
        );
      }
    }

    // Validate explanation is not empty
    if ((q['explanation'] as String).trim().isEmpty) {
      throw ValidationError('Question $i: Explanation cannot be empty');
    }

    // Validate explanation length (min 20 chars)
    if ((q['explanation'] as String).length < 20) {
      throw ValidationError(
        'Question $i: Explanation too short (min 20 characters)',
      );
    }
  }
}

Future<void> validateResourceFile(File file) async {
  final content = await file.readAsString();
  final data = json.decode(content) as Map<String, dynamic>;

  _assertHasKey(data, 'resources', 'Top level');
  _assertIsArray(data, 'resources');

  final resources = data['resources'] as List<dynamic>;

  for (var i = 0; i < resources.length; i++) {
    final r = resources[i];
    
    if (r is! Map<String, dynamic>) {
      throw ValidationError('Resource $i is not a JSON object');
    }

    _assertHasKey(r, 'type', 'Resource $i');
    _assertHasKey(r, 'title', 'Resource $i');
    _assertHasKey(r, 'content', 'Resource $i');

    // Validate type
    final validTypes = ['summary', 'formula', 'concept_map', 'exam_tip'];
    if (!validTypes.contains(r['type'])) {
      throw ValidationError('Resource $i: Invalid type "${r['type']}"');
    }
  }
}

void _assertHasKey(Map<String, dynamic> data, String key, String context) {
  if (!data.containsKey(key) || data[key] == null) {
    throw ValidationError('$context: Missing required field "$key"');
  }
}

void _assertIsArray(Map<String, dynamic> data, String key) {
  if (data[key] is! List) {
    throw ValidationError('Field "$key" must be an array');
  }
}

class ValidationError implements Exception {
  final String message;
  ValidationError(this.message);

  @override
  String toString() => message;
}
