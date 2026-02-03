// lib/features/flashcards/presentation/providers/flashcards_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/daos/flashcards_dao.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/features/flashcards/domain/usecases/get_flashcards_by_topic_usecase.dart';
import 'package:padhai/features/flashcards/domain/usecases/get_due_flashcards_usecase.dart';
import 'package:padhai/features/flashcards/domain/usecases/update_flashcard_mastery_usecase.dart';
import 'package:padhai/features/flashcards/domain/usecases/get_flashcard_stats_usecase.dart';

// Use case providers
final getFlashcardsByTopicUseCaseProvider = Provider((ref) {
  return GetFlashcardsByTopicUseCase(getIt<AppDatabase>());
});

final getDueFlashcardsUseCaseProvider = Provider((ref) {
  return GetDueFlashcardsUseCase(getIt<AppDatabase>());
});

final updateFlashcardMasteryUseCaseProvider = Provider((ref) {
  return UpdateFlashcardMasteryUseCase(getIt<AppDatabase>());
});

final getFlashcardStatsUseCaseProvider = Provider((ref) {
  return GetFlashcardStatsUseCase(getIt<AppDatabase>());
});

// Flashcard session state provider
final flashcardSessionProvider =
    StateNotifierProvider.family<FlashcardSessionNotifier, FlashcardSessionState, int>(
  (ref, topicId) {
    return FlashcardSessionNotifier(
      topicId: topicId,
      getFlashcardsByTopicUseCase: ref.watch(getFlashcardsByTopicUseCaseProvider),
      updateFlashcardMasteryUseCase: ref.watch(updateFlashcardMasteryUseCaseProvider),
    );
  },
);

// Flashcard stats provider
final flashcardStatsProvider = FutureProvider.family<FlashcardStats, int>((ref, topicId) async {
  final useCase = ref.watch(getFlashcardStatsUseCaseProvider);
  final result = await useCase(topicId);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
});

// Flashcard session state
class FlashcardSessionState {
  final List<Flashcard> flashcards;
  final int currentCardIndex;
  final bool isFlipped;
  final bool isLoading;
  final String? error;
  final Map<int, bool> responses; // flashcardId -> wasCorrect
  final bool isCompleted;

  FlashcardSessionState({
    this.flashcards = const [],
    this.currentCardIndex = 0,
    this.isFlipped = false,
    this.isLoading = false,
    this.error,
    this.responses = const {},
    this.isCompleted = false,
  });

  FlashcardSessionState copyWith({
    List<Flashcard>? flashcards,
    int? currentCardIndex,
    bool? isFlipped,
    bool? isLoading,
    String? error,
    Map<int, bool>? responses,
    bool? isCompleted,
  }) {
    return FlashcardSessionState(
      flashcards: flashcards ?? this.flashcards,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      responses: responses ?? this.responses,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Flashcard? get currentCard {
    if (currentCardIndex < flashcards.length) {
      return flashcards[currentCardIndex];
    }
    return null;
  }

  bool get isLastCard => currentCardIndex == flashcards.length - 1;

  int get reviewedCount => responses.length;

  int get correctCount => responses.values.where((correct) => correct).length;

  int get incorrectCount => responses.values.where((correct) => !correct).length;

  double get progress =>
      flashcards.isEmpty ? 0 : (currentCardIndex + 1) / flashcards.length;

  double get accuracy =>
      reviewedCount > 0 ? (correctCount / reviewedCount) * 100 : 0;
}

// Flashcard session notifier
class FlashcardSessionNotifier extends StateNotifier<FlashcardSessionState> {
  final int topicId;
  final GetFlashcardsByTopicUseCase _getFlashcardsByTopicUseCase;
  final UpdateFlashcardMasteryUseCase _updateFlashcardMasteryUseCase;

  FlashcardSessionNotifier({
    required this.topicId,
    required GetFlashcardsByTopicUseCase getFlashcardsByTopicUseCase,
    required UpdateFlashcardMasteryUseCase updateFlashcardMasteryUseCase,
  })  : _getFlashcardsByTopicUseCase = getFlashcardsByTopicUseCase,
        _updateFlashcardMasteryUseCase = updateFlashcardMasteryUseCase,
        super(FlashcardSessionState());

  Future<void> loadFlashcards() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getFlashcardsByTopicUseCase(topicId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (flashcards) {
        // Shuffle flashcards for varied learning
        flashcards.shuffle();
        state = state.copyWith(
          flashcards: flashcards,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  void flipCard() {
    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  Future<void> markAsCorrect() async {
    if (state.currentCard == null) return;

    final flashcardId = state.currentCard!.id;
    
    // Update mastery in database
    await _updateFlashcardMasteryUseCase(
      flashcardId: flashcardId,
      wasCorrect: true,
    );

    // Update local state
    final updatedResponses = Map<int, bool>.from(state.responses);
    updatedResponses[flashcardId] = true;

    state = state.copyWith(responses: updatedResponses);

    // Auto-advance to next card
    _advanceToNextCard();
  }

  Future<void> markAsIncorrect() async {
    if (state.currentCard == null) return;

    final flashcardId = state.currentCard!.id;

    // Update mastery in database
    await _updateFlashcardMasteryUseCase(
      flashcardId: flashcardId,
      wasCorrect: false,
    );

    // Update local state
    final updatedResponses = Map<int, bool>.from(state.responses);
    updatedResponses[flashcardId] = false;

    state = state.copyWith(responses: updatedResponses);

    // Auto-advance to next card
    _advanceToNextCard();
  }

  void _advanceToNextCard() {
    if (state.isLastCard) {
      // Session completed
      state = state.copyWith(isCompleted: true);
    } else {
      // Move to next card and reset flip state
      state = state.copyWith(
        currentCardIndex: state.currentCardIndex + 1,
        isFlipped: false,
      );
    }
  }

  void previousCard() {
    if (state.currentCardIndex > 0) {
      state = state.copyWith(
        currentCardIndex: state.currentCardIndex - 1,
        isFlipped: false,
      );
    }
  }

  void goToCard(int index) {
    if (index >= 0 && index < state.flashcards.length) {
      state = state.copyWith(
        currentCardIndex: index,
        isFlipped: false,
      );
    }
  }

  void restartSession() {
    state = FlashcardSessionState(flashcards: state.flashcards);
  }
}
