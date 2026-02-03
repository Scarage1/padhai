import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_analytics.dart';
import '../../domain/usecases/get_user_analytics_usecase.dart';

// State for analytics
class AnalyticsState {
  final bool isLoading;
  final UserAnalytics? analytics;
  final String? errorMessage;

  const AnalyticsState({
    this.isLoading = false,
    this.analytics,
    this.errorMessage,
  });

  AnalyticsState copyWith({
    bool? isLoading,
    UserAnalytics? analytics,
    String? errorMessage,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      analytics: analytics ?? this.analytics,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Provider
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final GetUserAnalyticsUseCase _getUserAnalyticsUseCase;
  final String userId;

  AnalyticsNotifier({
    required GetUserAnalyticsUseCase getUserAnalyticsUseCase,
    required this.userId,
  })  : _getUserAnalyticsUseCase = getUserAnalyticsUseCase,
        super(const AnalyticsState());

  Future<void> loadAnalytics() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _getUserAnalyticsUseCase(userId: userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (analytics) => state = state.copyWith(
        isLoading: false,
        analytics: analytics,
      ),
    );
  }
}

// Provider definition
final analyticsProvider =
    StateNotifierProvider.family<AnalyticsNotifier, AnalyticsState, String>(
  (ref, userId) {
    final getUserAnalyticsUseCase = ref.read(getUserAnalyticsUseCaseProvider);

    return AnalyticsNotifier(
      getUserAnalyticsUseCase: getUserAnalyticsUseCase,
      userId: userId,
    );
  },
);

// Use case provider
final getUserAnalyticsUseCaseProvider = Provider((ref) {
  final quizDao = ref.read(quizDaoProvider);
  final progressDao = ref.read(progressDaoProvider);
  final usersDao = ref.read(usersDaoProvider);
  final subjectsDao = ref.read(subjectsDaoProvider);

  return GetUserAnalyticsUseCase(
    quizDao: quizDao,
    progressDao: progressDao,
    usersDao: usersDao,
    subjectsDao: subjectsDao,
  );
});

// DAO providers (placeholders - should be in DI file)
final quizDaoProvider = Provider((ref) {
  throw UnimplementedError();
});

final progressDaoProvider = Provider((ref) {
  throw UnimplementedError();
});

final usersDaoProvider = Provider((ref) {
  throw UnimplementedError();
});

final subjectsDaoProvider = Provider((ref) {
  throw UnimplementedError();
});
