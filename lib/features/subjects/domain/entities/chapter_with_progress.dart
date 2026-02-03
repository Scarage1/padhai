// lib/features/subjects/domain/entities/chapter_with_progress.dart
import 'package:equatable/equatable.dart';
import 'package:padhai/core/database/app_database.dart';

class ChapterWithProgress extends Equatable {
  final Chapter chapter;
  final int totalTopics;
  final int completedTopics;
  final bool isUnlocked;

  const ChapterWithProgress({
    required this.chapter,
    required this.totalTopics,
    required this.completedTopics,
    required this.isUnlocked,
  });

  double get progressPercentage {
    if (totalTopics == 0) return 0.0;
    return (completedTopics / totalTopics) * 100;
  }

  bool get isCompleted => completedTopics == totalTopics && totalTopics > 0;

  @override
  List<Object?> get props => [chapter, totalTopics, completedTopics, isUnlocked];
}
