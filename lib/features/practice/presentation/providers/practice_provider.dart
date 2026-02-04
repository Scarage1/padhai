// lib/features/practice/presentation/providers/practice_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/features/practice/domain/usecases/start_practice_session_usecase.dart';
import 'package:padhai/features/practice/domain/usecases/record_practice_attempt_usecase.dart';
import 'package:padhai/features/practice/domain/usecases/get_practice_stats_usecase.dart';

// Use case providers
final startPracticeSessionUseCaseProvider = Provider((ref) {
  return StartPracticeSessionUseCase(getIt<AppDatabase>());
});

final recordPracticeAttemptUseCaseProvider = Provider((ref) {
  return RecordPracticeAttemptUseCase(getIt<AppDatabase>());
});

final getPracticeStatsUseCaseProvider = Provider((ref) {
  return GetPracticeStatsUseCase(getIt<AppDatabase>());
});

// Practice session state provider
final practiceSessionProvider =
    StateNotifierProvider.family<PracticeSessionNotifier, PracticeSessionState, String>(
  (ref, chapterId) {
    return PracticeSessionNotifier(
      chapterId: chapterId,
      startPracticeSessionUseCase: ref.watch(startPracticeSessionUseCaseProvider),
      recordPracticeAttemptUseCase: ref.watch(recordPracticeAttemptUseCaseProvider),
    );
  },
);

// Practice session state
class PracticeSessionState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final Map<int, String> selectedAnswers;
  final Set<int> hintsRevealed;
  final bool isLoading;
  final String? error;
  final bool isCompleted;

  PracticeSessionState({
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.hintsRevealed = const {},
    this.isLoading = false,
    this.error,
    this.isCompleted = false,
  });

  PracticeSessionState copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    Map<int, String>? selectedAnswers,
    Set<int>? hintsRevealed,
    bool? isLoading,
    String? error,
    bool? isCompleted,
  }) {
    return PracticeSessionState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      hintsRevealed: hintsRevealed ?? this.hintsRevealed,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Question? get currentQuestion {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  bool get isHintRevealed => hintsRevealed.contains(currentQuestionIndex);

  String? get selectedAnswer => selectedAnswers[currentQuestionIndex];

  bool get canProceed => selectedAnswer != null;

  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  int get totalHintsUsed => hintsRevealed.length;

  int get answeredCount => selectedAnswers.length;

  double get progress => questions.isEmpty ? 0 : (currentQuestionIndex + 1) / questions.length;
}

// Practice session notifier
class PracticeSessionNotifier extends StateNotifier<PracticeSessionState> {
  final String chapterId;
  final StartPracticeSessionUseCase _startPracticeSessionUseCase;
  final RecordPracticeAttemptUseCase _recordPracticeAttemptUseCase;

  PracticeSessionNotifier({
    required this.chapterId,
    required StartPracticeSessionUseCase startPracticeSessionUseCase,
    required RecordPracticeAttemptUseCase recordPracticeAttemptUseCase,
  })  : _startPracticeSessionUseCase = startPracticeSessionUseCase,
        _recordPracticeAttemptUseCase = recordPracticeAttemptUseCase,
        super(PracticeSessionState());

  Future<void> loadQuestions({int count = 10, String? difficulty}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _startPracticeSessionUseCase(
      chapterId: chapterId,
      count: count,
      difficulty: difficulty,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (questions) {
        state = state.copyWith(
          questions: questions,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  void selectAnswer(String answer) {
    final updatedAnswers = Map<int, String>.from(state.selectedAnswers);
    updatedAnswers[state.currentQuestionIndex] = answer;

    state = state.copyWith(selectedAnswers: updatedAnswers);
  }

  void revealHint() {
    final updatedHints = Set<int>.from(state.hintsRevealed);
    updatedHints.add(state.currentQuestionIndex);

    state = state.copyWith(hintsRevealed: updatedHints);
  }

  void nextQuestion() {
    if (!state.isLastQuestion) {
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

  void goToQuestion(int index) {
    if (index >= 0 && index < state.questions.length) {
      state = state.copyWith(currentQuestionIndex: index);
    }
  }

  Future<void> completePractice(String userId) async {
    final questionIds = state.questions.map((q) => q.id).toList();

    final result = await _recordPracticeAttemptUseCase(
      userId: userId,
      chapterId: chapterId,
      questionIds: questionIds,
      hintsUsed: state.totalHintsUsed,
    );

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (_) {
        state = state.copyWith(isCompleted: true);
      },
    );
  }
}
