// lib/features/progress/domain/services/progress_service.dart

/// Progress calculation for various entities
/// 
/// Topic Progress: % of content viewed + quiz completion
/// Chapter Progress: Average of topic progress
/// Subject Progress: Average of chapter progress
/// Overall Progress: Average of subject progress

class ProgressService {
  /// Calculate topic completion percentage
  /// 50% weight: Content viewed
  /// 50% weight: Quiz passed (≥60%)
  double calculateTopicProgress({
    required bool contentViewed,
    required double? quizPercentage,
  }) {
    double progress = 0;
    
    // Content viewed (50%)
    if (contentViewed) {
      progress += 50;
    }
    
    // Quiz passed (50%)
    if (quizPercentage != null && quizPercentage >= 60) {
      progress += 50;
    }
    
    return progress;
  }
  
  /// Calculate chapter completion percentage
  /// Average of all topic progress
  double calculateChapterProgress({
    required List<double> topicProgressList,
  }) {
    if (topicProgressList.isEmpty) return 0;
    
    final sum = topicProgressList.reduce((a, b) => a + b);
    return sum / topicProgressList.length;
  }
  
  /// Calculate subject completion percentage
  /// Average of all chapter progress
  double calculateSubjectProgress({
    required List<double> chapterProgressList,
  }) {
    if (chapterProgressList.isEmpty) return 0;
    
    final sum = chapterProgressList.reduce((a, b) => a + b);
    return sum / chapterProgressList.length;
  }
  
  /// Calculate overall completion percentage
  /// Average of all subject progress
  double calculateOverallProgress({
    required List<double> subjectProgressList,
  }) {
    if (subjectProgressList.isEmpty) return 0;
    
    final sum = subjectProgressList.reduce((a, b) => a + b);
    return sum / subjectProgressList.length;
  }
}
