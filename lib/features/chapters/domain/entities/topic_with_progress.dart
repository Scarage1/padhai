// lib/features/chapters/domain/entities/topic_with_progress.dart
import 'package:equatable/equatable.dart';
import 'package:padhai/core/database/app_database.dart';

class TopicWithProgress extends Equatable {
  final Topic topic;
  final bool isCompleted;
  final double? lastScore;
  final DateTime? lastAttemptAt;

  const TopicWithProgress({
    required this.topic,
    required this.isCompleted,
    this.lastScore,
    this.lastAttemptAt,
  });

  @override
  List<Object?> get props => [topic, isCompleted, lastScore, lastAttemptAt];
}
