// test/features/subjects/domain/services/chapter_unlock_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:padhai/features/subjects/domain/services/chapter_unlock_service.dart';

void main() {
  late ChapterUnlockService unlockService;
  
  setUp(() {
    unlockService = ChapterUnlockService();
  });
  
  group('isChapterUnlocked', () {
    test('first chapter is always unlocked', () {
      final result = unlockService.isChapterUnlocked(
        chapterOrder: 1,
        allChapterProgress: [],
      );
      expect(result, isTrue);
    });
    
    test('second chapter locked when first below 80%', () {
      final result = unlockService.isChapterUnlocked(
        chapterOrder: 2,
        allChapterProgress: [
          const ChapterProgress(chapterId: '1', chapterOrder: 1, progressPercentage: 70),
        ],
      );
      expect(result, isFalse);
    });
    
    test('second chapter unlocked when first at 80%+', () {
      final result = unlockService.isChapterUnlocked(
        chapterOrder: 2,
        allChapterProgress: [
          const ChapterProgress(chapterId: '1', chapterOrder: 1, progressPercentage: 80),
        ],
      );
      expect(result, isTrue);
    });
    
    test('third chapter requires second at 80%', () {
      final result = unlockService.isChapterUnlocked(
        chapterOrder: 3,
        allChapterProgress: [
          const ChapterProgress(chapterId: '1', chapterOrder: 1, progressPercentage: 100),
          const ChapterProgress(chapterId: '2', chapterOrder: 2, progressPercentage: 79),
        ],
      );
      expect(result, isFalse);
    });
  });
  
  group('getUnlockMessage', () {
    test('returns Unlocked for first chapter', () {
      final message = unlockService.getUnlockMessage(
        chapterOrder: 1,
        allChapterProgress: [],
      );
      expect(message, equals('Unlocked'));
    });
    
    test('returns requirement message for locked chapter', () {
      final message = unlockService.getUnlockMessage(
        chapterOrder: 2,
        allChapterProgress: [
          const ChapterProgress(chapterId: '1', chapterOrder: 1, progressPercentage: 60),
        ],
      );
      expect(message, equals('Complete 20% more of Chapter 1'));
    });
  });
}
