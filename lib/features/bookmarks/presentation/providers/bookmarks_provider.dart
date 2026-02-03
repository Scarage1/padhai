import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bookmarked_topic.dart';
import '../../domain/usecases/add_topic_bookmark_usecase.dart';
import '../../domain/usecases/remove_topic_bookmark_usecase.dart';
import '../../domain/usecases/get_bookmarked_topics_usecase.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// State for bookmarks
class BookmarksState {
  final bool isLoading;
  final List<BookmarkedTopic> bookmarks;
  final String? errorMessage;

  const BookmarksState({
    this.isLoading = false,
    this.bookmarks = const [],
    this.errorMessage,
  });

  BookmarksState copyWith({
    bool? isLoading,
    List<BookmarkedTopic>? bookmarks,
    String? errorMessage,
  }) {
    return BookmarksState(
      isLoading: isLoading ?? this.isLoading,
      bookmarks: bookmarks ?? this.bookmarks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Provider
class BookmarksNotifier extends StateNotifier<BookmarksState> {
  final GetBookmarkedTopicsUseCase _getBookmarkedTopicsUseCase;
  final AddTopicBookmarkUseCase _addTopicBookmarkUseCase;
  final RemoveTopicBookmarkUseCase _removeTopicBookmarkUseCase;
  final String userId;

  BookmarksNotifier({
    required GetBookmarkedTopicsUseCase getBookmarkedTopicsUseCase,
    required AddTopicBookmarkUseCase addTopicBookmarkUseCase,
    required RemoveTopicBookmarkUseCase removeTopicBookmarkUseCase,
    required this.userId,
  })  : _getBookmarkedTopicsUseCase = getBookmarkedTopicsUseCase,
        _addTopicBookmarkUseCase = addTopicBookmarkUseCase,
        _removeTopicBookmarkUseCase = removeTopicBookmarkUseCase,
        super(const BookmarksState());

  Future<void> loadBookmarks() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _getBookmarkedTopicsUseCase(userId: userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (bookmarks) => state = state.copyWith(
        isLoading: false,
        bookmarks: bookmarks,
      ),
    );
  }

  Future<bool> addBookmark(String topicId) async {
    final result = await _addTopicBookmarkUseCase(
      userId: userId,
      topicId: topicId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) {
        loadBookmarks(); // Refresh list
        return true;
      },
    );
  }

  Future<bool> removeBookmark(String topicId) async {
    final result = await _removeTopicBookmarkUseCase(
      userId: userId,
      topicId: topicId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) {
        loadBookmarks(); // Refresh list
        return true;
      },
    );
  }
}

// Provider definition
final bookmarksProvider =
    StateNotifierProvider.family<BookmarksNotifier, BookmarksState, String>(
  (ref, userId) {
    // Get dependencies from DI
    final getBookmarkedTopicsUseCase = ref.read(getBookmarkedTopicsUseCaseProvider);
    final addTopicBookmarkUseCase = ref.read(addTopicBookmarkUseCaseProvider);
    final removeTopicBookmarkUseCase = ref.read(removeTopicBookmarkUseCaseProvider);

    return BookmarksNotifier(
      getBookmarkedTopicsUseCase: getBookmarkedTopicsUseCase,
      addTopicBookmarkUseCase: addTopicBookmarkUseCase,
      removeTopicBookmarkUseCase: removeTopicBookmarkUseCase,
      userId: userId,
    );
  },
);

// Use case providers (to be added to DI)
final getBookmarkedTopicsUseCaseProvider = Provider((ref) {
  final bookmarksDao = ref.read(bookmarksDaoProvider);
  return GetBookmarkedTopicsUseCase(bookmarksDao);
});

final addTopicBookmarkUseCaseProvider = Provider((ref) {
  final bookmarksDao = ref.read(bookmarksDaoProvider);
  return AddTopicBookmarkUseCase(bookmarksDao);
});

final removeTopicBookmarkUseCaseProvider = Provider((ref) {
  final bookmarksDao = ref.read(bookmarksDaoProvider);
  return RemoveTopicBookmarkUseCase(bookmarksDao);
});

// DAO provider (should be in database providers file)
final bookmarksDaoProvider = Provider((ref) {
  final database = ref.read(databaseProvider);
  return database.bookmarksDao;
});

final databaseProvider = Provider((ref) {
  throw UnimplementedError('Database provider not yet implemented');
});
