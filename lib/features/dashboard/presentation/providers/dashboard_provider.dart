// lib/features/dashboard/presentation/providers/dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/features/auth/presentation/providers/auth_provider.dart';
import 'package:padhai/features/dashboard/domain/entities/user_stats.dart';
import 'package:padhai/features/dashboard/domain/usecases/get_subjects_usecase.dart';
import 'package:padhai/features/dashboard/domain/usecases/get_user_stats_usecase.dart';
import 'package:padhai/core/di/injection.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(
    getIt<GetSubjectsUseCase>(),
    getIt<GetUserStatsUseCase>(),
    ref,
  );
});

class DashboardState {
  final List<Subject> subjects;
  final UserStats? userStats;
  final bool isLoading;
  final String? error;

  const DashboardState({
    required this.subjects,
    this.userStats,
    required this.isLoading,
    this.error,
  });

  DashboardState copyWith({
    List<Subject>? subjects,
    UserStats? userStats,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      subjects: subjects ?? this.subjects,
      userStats: userStats ?? this.userStats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetSubjectsUseCase _getSubjectsUseCase;
  final GetUserStatsUseCase _getUserStatsUseCase;
  final Ref _ref;

  DashboardNotifier(
    this._getSubjectsUseCase,
    this._getUserStatsUseCase,
    this._ref,
  ) : super(const DashboardState(subjects: [], isLoading: false));

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get subjects
      final subjectsResult = await _getSubjectsUseCase();
      
      // Handle failure case
      if (subjectsResult.isLeft()) {
        subjectsResult.fold(
          (failure) {
            state = state.copyWith(
              isLoading: false,
              error: failure.message,
            );
          },
          (_) {},
        );
        return;
      }

      // Get subjects from result
      final subjects = subjectsResult.getOrElse((_) => []);

      // Get user stats
      final authState = _ref.read(authProvider);
      final userId = authState.user?.id;
      
      if (userId != null) {
        final statsResult = await _getUserStatsUseCase(userId);
        statsResult.fold(
          (failure) {
            state = state.copyWith(
              subjects: subjects,
              isLoading: false,
              error: failure.message,
            );
          },
          (stats) {
            state = state.copyWith(
              subjects: subjects,
              userStats: stats,
              isLoading: false,
            );
          },
        );
      } else {
        state = state.copyWith(
          subjects: subjects,
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

  void clearError() {
    state = state.copyWith(error: null);
  }
}
