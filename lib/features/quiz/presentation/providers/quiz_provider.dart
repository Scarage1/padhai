// lib/features/quiz/presentation/providers/quiz_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/features/auth/presentation/providers/auth_provider.dart';
import 'package:padhai/features/quiz/domain/usecases/get_questions_by_chapter_usecase.dart';
import 'package:padhai/features/quiz/domain/usecases/save_quiz_attempt_usecase.dart';

final quizProvider = StateNotifierProvider.family<QuizNotifier, QuizState, String>(
  (ref, chapterId) {
    return QuizNotifier(
      chapterId,
      getIt<GetQuestionsByChapterUseCase>(),
      getIt<SaveQuizAttemptUseCase>(),
      ref,
    );
  },
);

class QuizState {
  final Chapter? chapter;
  final List<Question> questions;
  final Map<int, String> userAnswers;
  final int currentQuestionIndex;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final DateTime? startedAt;
  final int? remainingSeconds;
  final String? attemptId;

  const QuizState({
    this.chapter,
    required this.questions,
    required this.userAnswers,
    required this.currentQuestionIndex,
    required this.isLoading,
    required this.isSubmitting,
    this.error,
    this.startedAt,
    this.remainingSeconds,
    this.attemptId,
  });

  QuizState copyWith({
    Chapter? chapter,
    List<Question>? questions,
    Map<int, String>? userAnswers,
    int? currentQuestionIndex,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    DateTime? startedAt,
    int? remainingSeconds,
    String? attemptId,
  }) {
    return QuizState(
      chapter: chapter ?? this.chapter,
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      startedAt: startedAt ?? this.startedAt,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      attemptId: attemptId ?? this.attemptId,
    );
  }

  bool get isCompleted => currentQuestionIndex >= questions.length;
  int get totalQuestions => questions.length;
  int get answeredCount => userAnswers.length;
}

class QuizNotifier extends StateNotifier<QuizState> {
  final String chapterId;
  final GetQuestionsByChapterUseCase _getQuestionsUseCase;
  final SaveQuizAttemptUseCase _saveQuizAttemptUseCase;
  final Ref _ref;
  Timer? _timer;

  QuizNotifier(
    this.chapterId,
    this._getQuestionsUseCase,
    this._saveQuizAttemptUseCase,
    this._ref,
  ) : super(const QuizState(
          questions: [],
          userAnswers: {},
          currentQuestionIndex: 0,
          isLoading: false,
          isSubmitting: false,
        ));

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadQuiz() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final database = getIt<AppDatabase>();
      final chapter = await database.chaptersDao.getChapterById(chapterId);

      if (chapter == null) {
        state = state.copyWith(isLoading: false, error: 'Chapter not found');
        return;
      }

      final authState = _ref.read(authProvider);
      if (authState.user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not authenticated',
        );
        return;
      }

      final result = await _getQuestionsUseCase(
        chapterId,
        authState.user!.id,
        limit: 10,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            chapter: chapter,
            isLoading: false,
            error: failure.message,
          );
        },
        (questions) {
          state = state.copyWith(
            chapter: chapter,
            questions: questions,
            isLoading: false,
            startedAt: DateTime.now(),
            remainingSeconds: questions.length * 60, // 1 minute per question
          );
          _startTimer();
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds != null && state.remainingSeconds! > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds! - 1);
      } else {
        timer.cancel();
        submitQuiz();
      }
    });
  }

  void selectAnswer(String answer) {
    final newAnswers = Map<int, String>.from(state.userAnswers);
    newAnswers[state.currentQuestionIndex] = answer;
    state = state.copyWith(userAnswers: newAnswers);
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  Future<void> submitQuiz() async {
    _timer?.cancel();
    state = state.copyWith(isSubmitting: true);

    try {
      final authState = _ref.read(authProvider);
      if (authState.user == null) return;

      final questionIds = state.questions.map((q) => q.id).toList();
      final userAnswers = <String>[];
      final isCorrectList = <bool>[];

      for (int i = 0; i < state.questions.length; i++) {
        final answer = state.userAnswers[i] ?? '';
        userAnswers.add(answer);
        isCorrectList.add(answer == state.questions[i].correctAnswer);
      }

      final result = await _saveQuizAttemptUseCase(
        userId: authState.user!.id,
        chapterId: chapterId,
        questionIds: questionIds,
        userAnswers: userAnswers,
        isCorrectList: isCorrectList,
        startedAt: state.startedAt ?? DateTime.now(),
        completedAt: DateTime.now(),
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            isSubmitting: false,
            error: failure.message,
          );
        },
        (attemptId) {
          state = state.copyWith(
            isSubmitting: false,
            attemptId: attemptId,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      );
    }
  }
}
