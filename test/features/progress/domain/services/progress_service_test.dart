// test/features/progress/domain/services/progress_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:padhai/features/progress/domain/services/progress_service.dart';

void main() {
  late ProgressService progressService;
  
  setUp(() {
    progressService = ProgressService();
  });
  
  group('calculateTopicProgress', () {
    test('returns 0 when neither content viewed nor quiz passed', () {
      final progress = progressService.calculateTopicProgress(
        contentViewed: false,
        quizPercentage: null,
      );
      expect(progress, equals(0.0));
    });
    
    test('returns 50 when only content viewed', () {
      final progress = progressService.calculateTopicProgress(
        contentViewed: true,
        quizPercentage: null,
      );
      expect(progress, equals(50.0));
    });
    
    test('returns 50 when content viewed but quiz failed', () {
      final progress = progressService.calculateTopicProgress(
        contentViewed: true,
        quizPercentage: 50.0, // Below 60%
      );
      expect(progress, equals(50.0));
    });
    
    test('returns 100 when both completed', () {
      final progress = progressService.calculateTopicProgress(
        contentViewed: true,
        quizPercentage: 75.0,
      );
      expect(progress, equals(100.0));
    });
  });
  
  group('calculateChapterProgress', () {
    test('returns 0 when no topics', () {
      final progress = progressService.calculateChapterProgress(
        topicProgressList: [],
      );
      expect(progress, equals(0.0));
    });
    
    test('calculates average correctly', () {
      final progress = progressService.calculateChapterProgress(
        topicProgressList: [100.0, 50.0, 0.0],
      );
      expect(progress, equals(50.0));
    });
  });
  
  group('calculateSubjectProgress', () {
    test('calculates average of chapters', () {
      final progress = progressService.calculateSubjectProgress(
        chapterProgressList: [80.0, 60.0, 40.0, 20.0],
      );
      expect(progress, equals(50.0));
    });
  });
}
