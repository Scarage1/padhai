import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/core/database/app_database.dart';
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

// DAO providers using GetIt
final quizDaoProvider = Provider((ref) {
  return getIt<AppDatabase>().quizDao;
});

final progressDaoProvider = Provider((ref) {
  return getIt<AppDatabase>().progressDao;
});

final usersDaoProvider = Provider((ref) {
  return getIt<AppDatabase>().usersDao;
});

final subjectsDaoProvider = Provider((ref) {
  return getIt<AppDatabase>().subjectsDao;
});
