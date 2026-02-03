// lib/features/subjects/domain/services/chapter_unlock_service.dart
import 'package:collection/collection.dart';

/// Chapter unlock rules
/// 
/// Rule 1: First chapter of each subject is always unlocked
/// Rule 2: Subsequent chapters unlock when previous chapter reaches 80% progress
/// 
/// This ensures students complete topics before moving forward

class ChapterUnlockService {
  static const double unlockThreshold = 80.0;
  
  /// Check if a chapter is unlocked
  bool isChapterUnlocked({
    required int chapterOrder,
    required List<ChapterProgress> allChapterProgress,
  }) {
    // First chapter is always unlocked
    if (chapterOrder == 1) return true;
    
    // Find previous chapter's progress
    final previousChapterProgress = allChapterProgress
        .firstWhereOrNull((cp) => cp.chapterOrder == chapterOrder - 1);
    
    if (previousChapterProgress == null) return false;
    
    return previousChapterProgress.progressPercentage >= unlockThreshold;
  }
  
  /// Get next unlock requirement message
  String getUnlockMessage({
    required int chapterOrder,
    required List<ChapterProgress> allChapterProgress,
  }) {
    if (chapterOrder == 1) return 'Unlocked';
    
    final previousChapter = allChapterProgress
        .firstWhereOrNull((cp) => cp.chapterOrder == chapterOrder - 1);
    
    if (previousChapter == null) {
      return 'Complete Chapter ${chapterOrder - 1} to unlock';
    }
    
    final remaining = unlockThreshold - previousChapter.progressPercentage;
    
    if (remaining <= 0) return 'Unlocked';
    
    return 'Complete ${remaining.toInt()}% more of Chapter ${chapterOrder - 1}';
  }
}

class ChapterProgress {
  final String chapterId;
  final int chapterOrder;
  final double progressPercentage;
  
  const ChapterProgress({
    required this.chapterId,
    required this.chapterOrder,
    required this.progressPercentage,
  });
}
