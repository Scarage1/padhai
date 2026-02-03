// lib/features/chapters/presentation/providers/chapter_detail_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/features/auth/presentation/providers/auth_provider.dart';
import 'package:padhai/features/chapters/domain/entities/topic_with_progress.dart';
import 'package:padhai/features/chapters/domain/usecases/get_topics_by_chapter_usecase.dart';

final chapterDetailProvider = StateNotifierProvider.family<
    ChapterDetailNotifier, ChapterDetailState, String>((ref, chapterId) {
  return ChapterDetailNotifier(
    chapterId,
    getIt<GetTopicsByChapterUseCase>(),
    ref,
  );
});

class ChapterDetailState {
  final Chapter? chapter;
  final List<TopicWithProgress> topics;
  final bool isLoading;
  final String? error;

  const ChapterDetailState({
    this.chapter,
    required this.topics,
    required this.isLoading,
    this.error,
  });

  ChapterDetailState copyWith({
    Chapter? chapter,
    List<TopicWithProgress>? topics,
    bool? isLoading,
    String? error,
  }) {
    return ChapterDetailState(
      chapter: chapter ?? this.chapter,
      topics: topics ?? this.topics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChapterDetailNotifier extends StateNotifier<ChapterDetailState> {
  final String chapterId;
  final GetTopicsByChapterUseCase _getTopicsByChapterUseCase;
  final Ref _ref;

  ChapterDetailNotifier(
    this.chapterId,
    this._getTopicsByChapterUseCase,
    this._ref,
  ) : super(const ChapterDetailState(topics: [], isLoading: false));

  Future<void> loadChapterDetail() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get chapter info
      final database = getIt<AppDatabase>();
      final chapter = await database.chaptersDao.getChapterById(chapterId);

      if (chapter == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Chapter not found',
        );
        return;
      }

      // Get topics with progress
      final authState = _ref.read(authProvider);
      if (authState.user != null) {
        final result = await _getTopicsByChapterUseCase(
          chapterId,
          authState.user!.id,
        );

        result.fold(
          (failure) {
            state = state.copyWith(
              chapter: chapter,
              isLoading: false,
              error: failure.message,
            );
          },
          (topics) {
            state = state.copyWith(
              chapter: chapter,
              topics: topics,
              isLoading: false,
            );
          },
        );
      } else {
        state = state.copyWith(
          chapter: chapter,
          isLoading: false,
          error: 'User not authenticated',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
