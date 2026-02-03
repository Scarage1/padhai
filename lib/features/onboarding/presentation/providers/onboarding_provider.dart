// lib/features/onboarding/presentation/providers/onboarding_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/storage/secure_storage.dart';
import 'package:padhai/core/di/injection.dart';

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(getIt<SecureStorage>());
});

class OnboardingState {
  final int currentPage;
  final bool isLoading;

  const OnboardingState({
    required this.currentPage,
    required this.isLoading,
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? isLoading,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final SecureStorage _secureStorage;

  OnboardingNotifier(this._secureStorage)
      : super(const OnboardingState(currentPage: 0, isLoading: false));

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true);
    try {
      await _secureStorage.saveOnboardingCompleted(true);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
