// lib/features/topics/presentation/providers/topic_detail_provider.dart
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/features/auth/presentation/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final topicDetailProvider = StateNotifierProvider.family<
    TopicDetailNotifier, TopicDetailState, String>((ref, topicId) {
  return TopicDetailNotifier(topicId, ref);
});

class TopicDetailState {
  final Topic? topic;
  final TopicProgressData? progress;
  final bool isLoading;
  final String? error;

  const TopicDetailState({
    this.topic,
    this.progress,
    required this.isLoading,
    this.error,
  });

  TopicDetailState copyWith({
    Topic? topic,
    TopicProgressData? progress,
    bool? isLoading,
    String? error,
  }) {
    return TopicDetailState(
      topic: topic ?? this.topic,
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TopicDetailNotifier extends StateNotifier<TopicDetailState> {
  final String topicId;
  final Ref _ref;

  TopicDetailNotifier(this.topicId, this._ref)
      : super(const TopicDetailState(isLoading: false));

  Future<void> loadTopicDetail() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final database = getIt<AppDatabase>();
      final topic = await database.topicsDao.getTopicById(topicId);

      if (topic == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Topic not found',
        );
        return;
      }

      // Get progress
      final authState = _ref.read(authProvider);
      if (authState.user != null) {
        final progress = await database.progressDao.getTopicProgress(
          authState.user!.id,
          topicId,
        );

        state = state.copyWith(
          topic: topic,
          progress: progress,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          topic: topic,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> markAsCompleted() async {
    final authState = _ref.read(authProvider);
    if (authState.user == null || state.topic == null) return;

    try {
      final database = getIt<AppDatabase>();
      await database.progressDao.upsertTopicProgress(
        TopicProgressCompanion.insert(
          id: _uuid.v4(),
          userId: authState.user!.id,
          topicId: state.topic!.id,
          isCompleted: Value(true),
          lastAccessedAt: DateTime.now(),
        ),
      );

      // Reload to get updated progress
      await loadTopicDetail();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
