// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/features/auth/domain/entities/user.dart';
import 'package:padhai/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:padhai/features/auth/domain/usecases/login_usecase.dart';
import 'package:padhai/features/auth/domain/usecases/logout_usecase.dart';
import 'package:padhai/features/auth/domain/usecases/register_usecase.dart';

// Auth state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthNotifier(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  ) : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) => state = state.copyWith(isAuthenticated: false),
      (user) => state = state.copyWith(
        user: user,
        isAuthenticated: user != null,
      ),
    );
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase(email, password);
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
        );
        return true;
      },
    );
  }

  Future<bool> register(String email, String name, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _registerUseCase(email, name, password);
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
        );
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _logoutUseCase();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    getIt<LoginUseCase>(),
    getIt<RegisterUseCase>(),
    getIt<LogoutUseCase>(),
    getIt<GetCurrentUserUseCase>(),
  );
});
