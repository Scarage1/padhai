// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/error/exceptions.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/core/network/network_info.dart';
import 'package:padhai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:padhai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:padhai/features/auth/domain/entities/user.dart';
import 'package:padhai/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // For v1.0.0, using offline-first approach
      final response = await _remoteDataSource.login(email, password);
      final userData = response['user'] as Map<String, dynamic>;

      final user = User(
        id: userData['id'] as String,
        email: userData['email'] as String,
        name: userData['name'] as String,
        classNumber: userData['class_number'] as int,
        createdAt: DateTime.parse(userData['created_at'] as String),
        lastLoginAt: DateTime.now(),
        hasCompletedOnboarding:
            userData['has_completed_onboarding'] as bool? ?? false,
        currentDifficulty: userData['current_difficulty'] as String,
        streakDays: userData['streak_days'] as int,
      );

      await _localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String email,
    String name,
    String password,
  ) async {
    try {
      final response = await _remoteDataSource.register(email, name, password);
      final userData = response['user'] as Map<String, dynamic>;

      final user = User(
        id: userData['id'] as String,
        email: userData['email'] as String,
        name: userData['name'] as String,
        classNumber: userData['class_number'] as int,
        createdAt: DateTime.parse(userData['created_at'] as String),
        hasCompletedOnboarding:
            userData['has_completed_onboarding'] as bool? ?? false,
        currentDifficulty: userData['current_difficulty'] as String,
        streakDays: userData['streak_days'] as int,
      );

      await _localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getCurrentUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isAuth = await _localDataSource.isAuthenticated();
      return Right(isAuth);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
