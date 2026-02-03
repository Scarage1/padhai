// lib/features/subjects/presentation/providers/subject_detail_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/features/auth/presentation/providers/auth_provider.dart';
import 'package:padhai/features/subjects/domain/entities/chapter_with_progress.dart';
import 'package:padhai/features/subjects/domain/usecases/get_chapters_by_subject_usecase.dart';

final subjectDetailProvider = StateNotifierProvider.family<
    SubjectDetailNotifier, SubjectDetailState, String>((ref, subjectId) {
  return SubjectDetailNotifier(
    subjectId,
    getIt<GetChaptersBySubjectUseCase>(),
    ref,
  );
});

class SubjectDetailState {
  final Subject? subject;
  final List<ChapterWithProgress> chapters;
  final bool isLoading;
  final String? error;

  const SubjectDetailState({
    this.subject,
    required this.chapters,
    required this.isLoading,
    this.error,
  });

  SubjectDetailState copyWith({
    Subject? subject,
    List<ChapterWithProgress>? chapters,
    bool? isLoading,
    String? error,
  }) {
    return SubjectDetailState(
      subject: subject ?? this.subject,
      chapters: chapters ?? this.chapters,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SubjectDetailNotifier extends StateNotifier<SubjectDetailState> {
  final String subjectId;
  final GetChaptersBySubjectUseCase _getChaptersBySubjectUseCase;
  final Ref _ref;

  SubjectDetailNotifier(
    this.subjectId,
    this._getChaptersBySubjectUseCase,
    this._ref,
  ) : super(const SubjectDetailState(chapters: [], isLoading: false));

  Future<void> loadSubjectDetail() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get subject info
      final database = getIt<AppDatabase>();
      final subject = await database.subjectsDao.getSubjectById(subjectId);

      if (subject == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Subject not found',
        );
        return;
      }

      // Get chapters with progress
      final authState = _ref.read(authProvider);
      if (authState.user != null) {
        final result = await _getChaptersBySubjectUseCase(
          subjectId,
          authState.user!.id,
        );

        result.fold(
          (failure) {
            state = state.copyWith(
              subject: subject,
              isLoading: false,
              error: failure.message,
            );
          },
          (chapters) {
            state = state.copyWith(
              subject: subject,
              chapters: chapters,
              isLoading: false,
            );
          },
        );
      } else {
        state = state.copyWith(
          subject: subject,
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
