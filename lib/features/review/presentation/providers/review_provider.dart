import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/incorrect_answer.dart';
import '../../domain/usecases/get_incorrect_answers_usecase.dart';

// State for review
class ReviewState {
  final bool isLoading;
  final List<IncorrectAnswer> incorrectAnswers;
  final String? errorMessage;

  const ReviewState({
    this.isLoading = false,
    this.incorrectAnswers = const [],
    this.errorMessage,
  });

  ReviewState copyWith({
    bool? isLoading,
    List<IncorrectAnswer>? incorrectAnswers,
    String? errorMessage,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Provider
class ReviewNotifier extends StateNotifier<ReviewState> {
  final GetIncorrectAnswersUseCase _getIncorrectAnswersUseCase;
  final String userId;

  ReviewNotifier({
    required GetIncorrectAnswersUseCase getIncorrectAnswersUseCase,
    required this.userId,
  })  : _getIncorrectAnswersUseCase = getIncorrectAnswersUseCase,
        super(const ReviewState());

  Future<void> loadIncorrectAnswers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _getIncorrectAnswersUseCase(userId: userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (answers) => state = state.copyWith(
        isLoading: false,
        incorrectAnswers: answers,
      ),
    );
  }
}

// Provider definition
final reviewProvider =
    StateNotifierProvider.family<ReviewNotifier, ReviewState, String>(
  (ref, userId) {
    final getIncorrectAnswersUseCase = ref.read(getIncorrectAnswersUseCaseProvider);

    return ReviewNotifier(
      getIncorrectAnswersUseCase: getIncorrectAnswersUseCase,
      userId: userId,
    );
  },
);

// Use case provider
final getIncorrectAnswersUseCaseProvider = Provider((ref) {
  final quizDao = ref.read(quizDaoProvider);
  return GetIncorrectAnswersUseCase(quizDao);
});

// DAO provider (placeholder)
final quizDaoProvider = Provider((ref) {
  throw UnimplementedError();
});
