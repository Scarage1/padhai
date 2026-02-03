// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String name, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isAuthenticated();
}
